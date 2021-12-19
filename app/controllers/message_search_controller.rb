class MessageSearchController < ApplicationController

    def search
        return render :json => (Message.search query:{match: {body: params[:query]}}).results.as_json
    end
end
  