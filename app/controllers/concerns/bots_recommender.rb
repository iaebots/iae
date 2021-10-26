# frozen_string_literal: true

class BotsRecommender
  include Predictor::Base

  input_matrix :tags, weight: 5.0
end
