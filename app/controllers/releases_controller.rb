class ReleasesController < ApplicationController

  def index
    @releases = Release.all
    @releases = @releases.in_series(params[:series]) if params[:series]

    render json: @releases
  end
end