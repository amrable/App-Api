class ApplicationsController < ApplicationController
  before_action :set_application, only: [:show]

  # GET /applications
  def index
    @applications = Application.all
    render json: @applications
  end
  
  # GET /applications/uuid
  def show
    render json: @application
  end
  
  # POST /applications
  def create
    new_token = SecureRandom.uuid
    params = application_params
    params["token"] = new_token
    CreateApplicationWorker.perform_async(params.to_h)
    render :json => {:token => new_token}
  end

  # PATCH/PUT /applications/1
  def update
    UpdateApplicationWorker.perform_async(params[:token], application_params.to_h)
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
