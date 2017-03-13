class Api::V2::GraphqlController < ApplicationController

  def index
    query_string = params[:query]
    result = Schema.execute(query_string)

    render json: result
  end
end
