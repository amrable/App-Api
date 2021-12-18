class UpdateApplicationWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(token, params)
        @application = Application.where(token: token)[0]
        if @application.last_request_timestamp == nil or @application.last_request_timestamp < params["last_request_timestamp"]
            @application.update(params)
        end
    end
end