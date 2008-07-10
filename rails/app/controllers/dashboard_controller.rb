class DashboardController < ApplicationController
  def index
    @failed_nodes = Node.failed
  end
end
