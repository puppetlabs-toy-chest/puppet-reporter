class NodesController < ApplicationController
  before_filter :get_node, :only => [:show, :failures, :reports]
  
  def index
    @nodes = Node.find(:all)
  end
  
  def show
    @most_recent_report = @node.most_recent_report_on(Time.zone.now)
  end
  
  def failures
    @failures = @node.failures
    render :layout => false, :content_type => 'text/plain'
  end

  
  def reports
    @reports = @node.reports.find(:all, :limit => 100, :order => 'timestamp desc').sort_by(&:timestamp)
  end
  
  
  private
  
  def get_node
    if params[:id] =~ /^\d+$/
      @node = Node.find(params[:id]) rescue nil
    else
      @node = Node.find_by_name(CGI.unescape(params[:id])) unless params[:id].blank?
    end
    
    if @node
      true
    else
      flash[:notice] = 'Could not find information for that node.'
      redirect_to(nodes_path)
      false
    end
  end
end
