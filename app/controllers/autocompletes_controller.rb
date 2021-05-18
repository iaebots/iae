class AutocompletesController < ApplicationController
  before_action :query_params, only: %i[show]

  # Returns a JSON with the tags and developers' and bots' usernames
  # that looks like users' input
  def show
   response = Tag.find_by_sql(["
     SELECT name FROM Tags
     WHERE name ~* ?
     UNION
     SELECT username FROM Developers
     WHERE username ~* ?
     UNION
     SELECT username FROM Bots
     WHERE username ~* ?
     LIMIT 5", params[:query], params[:query], params[:query]])
     .pluck(:name) # pluck turns object into array

    render json: response.to_json
  end

  private

  # Require query from autocomplete_controller.js
  def query_params
    params.require(:query)
  end
end
