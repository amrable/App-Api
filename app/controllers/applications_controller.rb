class ApplicationsController < ApplicationController
  before_action :set_application, only: [:show]

  # GET /applications
  def index
    @applications = Application.select("token", "name", "chats_count")
    render json: @applications
  end
  
  # GET /applications/uuid
  def show
    render json: @application.select("token", "name", "chats_count")
  end
  
  # POST /applications
  def create
    new_token = SecureRandom.uuid
    worker_params = application_params
    worker_params["token"] = new_token
    worker_params["last_request_timestamp"] = DateTime.now
    CreateApplicationWorker.perform_async(worker_params.to_h)
    render :json => {:token => new_token}
  end

  # PATCH/PUT /applications/1
  def update
    worker_params = application_params
    worker_params["last_request_timestamp"] = DateTime.now
    UpdateApplicationWorker.perform_async(params[:token], worker_params.to_h)
    render :json => {:status => "Request has been sent."}
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.where(token: params[:token])
    end

    # Only allow a trusted parameter "white list" through.
    def application_params
      params.require(:application).permit(:name)
    end
end
