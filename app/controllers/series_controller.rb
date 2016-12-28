class SeriesController < ApplicationController
  def index
    @series = Series.all
    render json: @series
  end
end