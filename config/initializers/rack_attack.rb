class Rack::Attack

    ### Configure Cache ###

    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new 

    ### Throttle Spammy Clients ###

    # Throttle all requests by IP (60rpm)

    # Max 300 requests per 5 minutes
    throttle('req/ip', limit: 200, period: 5.minutes) do |req|
      req.ip 
    end

    # Prevent too many POST requests on sing in pages

    throttle('developers/sign_in/ip', limit: 20, period: 20.seconds) do |req|
        if req.path == '/developers/sign_in' && req.post?
            req.ip
        end     
    end

    throttle('guests/sign_in/ip', limit: 20, period: 20.seconds) do |req|
        if req.path == '/guests/sign_in' && req.post?
            req.ip
        end     
    end
end 