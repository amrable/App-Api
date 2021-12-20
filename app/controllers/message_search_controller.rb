class MessageSearchController < ApplicationController

    def search
        result = (Message.search query:{match: {body: params[:query]}}).results.as_json
        response = []
        result.each do |k|
            k = k ['_source']
            k['message_number'] = k['number']
            k.delete('number')
            response.append(k)
        end
        return render :json => response
    end
end
  