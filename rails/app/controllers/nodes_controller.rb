class NodesController < ApplicationController
  def show
    if params[:name]
      @node = Node.find_by_name(params[:name])
    else
      @node = Node.find(params[:id]) rescue nil
    end
    
    unless @node
      flash[:notice] = 'Could not find information for that node.'
      return redirect_to(nodes_path)
    end
  end
end
