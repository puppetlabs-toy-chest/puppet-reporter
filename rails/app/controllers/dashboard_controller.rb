class DashboardController < ApplicationController
  def index
    @failed_nodes = Node.failed
    @silent_nodes = Node.silent
    
    @logs = Log.latest
  end

  def search
    @results = Node.search(params[:q])
  end
end
