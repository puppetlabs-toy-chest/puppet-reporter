class DashboardController < ApplicationController
  def index
    @failed_nodes = Node.failed
    @silent_nodes = Node.silent

    @logs = Log.latest
  end

  def search
    @q = params[:q]
    @results = Node.search(:conditions => SearchParser.parse(@q),
                           :page => params[:page],
                           :per_page => 2)
  end
end
