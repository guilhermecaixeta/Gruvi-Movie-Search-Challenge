class Api::V1::MovieController < ApplicationController
  include RescueConcern

  def search
    service = Services::MovieService.new()
    movies = service.fetch(permitted_params)
    render json: movies, status: movies[:data].empty? ? :no_content : :ok
  end

  private
  def permitted_params
    @permitted_params ||= params.permit(:start_date, :end_date, :page)
  end
end
