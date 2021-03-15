class AutocompletesController < ApplicationController
  before_action :query_params, only: %i[show]

  # Returns a JSON with the name of tags that looks like users' input
  def show
   response = Tag.find_by_sql("
     SELECT name
     FROM Tags
     WHERE name LIKE '%#{params[:query]}%'")
     .pluck(:name) # pluck turns object into array

    render json: response.to_json
  end

  private

  # Require query from autocomplete_controller.js
  def query_params
    params.require(:query)
  end
end
