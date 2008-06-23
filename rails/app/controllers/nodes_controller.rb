class NodesController < ApplicationController
  def index
    @nodes = Node.find(:all)
  end
  
  def show
    if params[:id] =~ /^\d+$/
      @node = Node.find(params[:id]) rescue nil
    else
      @node = Node.find_by_name(CGI.unescape(params[:id])) unless params[:id].blank?
    end
    
    unless @node
      flash[:notice] = 'Could not find information for that node.'
      return redirect_to(nodes_path)
    end
    
    @most_recent_report = @node.most_recent_report_on(Time.zone.now)
  end
  
  def failures
    if params[:id] =~ /^\d+$/
      @node = Node.find(params[:id]) rescue nil
    else
      @node = Node.find_by_name(CGI.unescape(params[:id])) unless params[:id].blank?
    end
    
    unless @node
      flash[:notice] = 'Could not find information for that node.'
      return redirect_to(nodes_path)
    end
    
    @failures = @node.failures
    render :layout => false, :content_type => 'text/plain'
  end
end
