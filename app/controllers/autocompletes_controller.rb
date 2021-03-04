class AutocompletesController < ApplicationController
  def show
    response = Tag.pluck(:name).sort

    render json: response.to_json
  end
end
