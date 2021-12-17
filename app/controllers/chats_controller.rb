class ChatsController < ApplicationController
  before_action :set_chat, only: [:show, :index]

  # GET /applications/:application_token/chats
  def index
    render json: @chats
  end

  # GET /applications/:application_token/chats/:number
  def show
    # TBD: index on (application id, number)
    @chat = @chats.where(number: params[:number])
    render json: @chat
  end

  # POST /chats
  def create
    CreateChatWorker.perform_async(params[:application_token])
    render :json => {:number => 1} # TBD: Read from cache / DB
  end

  # PATCH/PUT /chats/1
  # def update
  #   if @chat.update(chat_params)
  #     render json: @chat
  #   else
  #     render json: @chat.errors, status: :unprocessable_entity
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @application = Application.where(token: params[:application_token])[0]
      @chats = Chat.where(application_id: @application.id)
    end

    # Only allow a trusted parameter "white list" through.
    # def chat_params
    #   params.require(:chat).permit(:number)
    # end
end
