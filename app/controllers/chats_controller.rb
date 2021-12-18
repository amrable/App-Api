class ChatsController < ApplicationController
  before_action :set_chat, only: [:show, :index]
  def initialize
    @semaphore = Mutex.new
  end

  def synchronize(&block)
    @semaphore.synchronize(&block)
  end

  # GET /applications/:application_token/chats
  def index
    @chats = Chat.where(application_id: @application.id)
    render json: @chats
  end

  # GET /applications/:application_token/chats/:number
  def show
    @chat = Chat.where(application_id: @application.id, number: params[:number])
    render json: @chat
  end

  # POST /chats
  def create
    worker_params = {}
    worker_params["last_request_timestamp"] = DateTime.now
    synchronize do
      if !REDIS.get(params[:application_token]).present?
        REDIS.set(params[:application_token], Application.where(token: params[:application_token])[0].chats.size)
      end
      worker_params["number"] = REDIS.get(params[:application_token]).to_i + 1
      REDIS.set(params[:application_token], worker_params["number"])
    end
    CreateChatWorker.perform_async(params[:application_token], worker_params.to_h)
    render :json => {:number => worker_params["number"]} 
  end

  # PATCH/PUT /chats/1
  def update
    worker_params = chat_params
    worker_params["last_request_timestamp"] = DateTime.now
    UpdateChatWorker.perform_async(params[:application_token], params[:number], worker_params.to_h)
    render :json => {:status => "success"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @application = Application.where(token: params[:application_token])[0]
    end

    # Only allow a trusted parameter "white list" through.
    def chat_params
      params.require(:chat).permit(:title)
    end
end
