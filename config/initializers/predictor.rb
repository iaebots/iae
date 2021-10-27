# frozen_string_literal: true

Predictor.redis = Redis.new(url: ENV['PREDICTOR_REDIS'], driver: :hiredis)
