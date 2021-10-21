# frozen_string_literal: true

# RackAttack https://github.com/rack/rack-attack
module Rack
  # Mitigates abusive requests
  class Attack
    # Throttle all requests to any route by IP (50rpm/IP)
    throttle('req/ip', limit: 100, period: 1.minute, &:ip)

    # Ban IP for 1 hour after 500 requests in 5 minutes
    Rack::Attack.blocklist('ban on too many requests') do |req|
      Rack::Attack::Allow2Ban.filter(req.ip, maxretry: 500, findtime: 5.minutes, bantime: 1.hour) do
        true
      end
    end

    # Prevent too many POST requests on sing-in pages
    throttle('sign_in/ip', limit: 20, period: 20.seconds) do |req|
      req.ip if req.path == '/developers/sign_in' && req.post?
    end

    # Ban IP for 12 hours after 30 sign-ups in 1 hour
    # Prevents a single user from creating too many accounts
    Rack::Attack.blocklist('ban on too many sign-ups') do |req|
      Rack::Attack::Allow2Ban.filter(req.ip, maxretry: 30, findtime: 1.hour, bantime: 12.hours) do
        (req.path == '/developers/sign_up' || req.path == '/developers') && req.post?
      end
    end
  end

  # Ban IP for 12 hours after 50 sign-in attempts in 5 minutes
  Rack::Attack.blocklist('ban on too man sing-ins attempts') do |req|
    Rack::Attack::Allow2Ban.filter(req.ip, maxretry: 50, findtime: 5.minutes, bantime: 24.hours) do
      req.path == '/developers/sign_in' && req.post?
    end
  end

  # Using 503 because it may make attacker think that they have successfully
  # DOSed the site.
  Rack::Attack.blocklisted_response = lambda do |_env|
    [503, {}, ["Blocked\n"]]
  end

  Rack::Attack.throttled_response = lambda do |_env|
    [503, {}, ["Server error\n"]]
  end
end

# Log rack-attack events
ActiveSupport::Notifications.subscribe(/rack_attack/) do |_name, _start, _finish, _request_id, payload|
  req = payload[:request]
  remote_ip = req.env['HTTP_X_FORWARDED_FOR'].presence || req.env['REMOTE_ADDR'].presence
  url = req.env['REQUEST_URI'].presence
  Rails.logger.info '[Rack::Attack][PostApp]' \
                    " remote_ip: \"#{remote_ip}\"," \
                    " request_uri: #{url}"
end
