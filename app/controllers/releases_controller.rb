class ReleasesController < ApplicationController
  PAGE_LIMIT = 20

  def index
    @page = params[:page] || 1
    @releases = Release.order(released_at: :desc)
    @releases = @releases.in_series(params[:series]) if params[:series]
    @releases = @releases.page(@page).per(PAGE_LIMIT)

    respond_to do |format|
      format.html
      format.json { render json: { releases: @releases, page: @page, total_count: @releases.total_count } }
    end
  end
end