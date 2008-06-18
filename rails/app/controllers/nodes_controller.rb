class NodesController < ApplicationController
  def index
    @nodes = Node.find(:all)
  end
  
  def show
    if params[:id] =~ /^\d+$/
      @node = Node.find(params[:id]) rescue nil
    else
      @node = Node.find_by_name(params[:id])
    end
    
    unless @node
      flash[:notice] = 'Could not find information for that node.'
      return redirect_to(nodes_path)
    end
  end
end
