class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :index]

  # GET /messages
  def index
    @messages = Message.where(chat_id: @chat.id)
    render json: @messages
  end

  # GET /messages/1
  def show
    @message = Message.where(chat_id: @chat.id, number: params[:number])
    render json: @message
  end

  # POST /messages
  def create
    CreateMessageWorker.perform_async(params[:application_token], params[:chat_number], message_params[:body])
    render :json => {:number => 1} # TBD: Read from cache / DB
  end

  # PATCH/PUT /messages/1
  def update
    UpdateMessageWorker.perform_async(params[:application_token], params[:chat_number], params[:number], message_params.to_h)
    render :json => {:status => "success"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message 
      @application = Application.where(token: params[:application_token])[0]
      @chat = Chat.where(application_id: @application.id, number: params[:chat_number])[0]
    end
    
    # Only allow a trusted parameter "white list" through.
    def message_params
      params.require(:message).permit(:body)
    end
end
