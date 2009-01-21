class DashboardController < ApplicationController
  def index
  end

  def search
    @q = params[:q]
    search_model = params[:context] == 'log' ? Log : Node
    @results = search_model.search(:conditions => SearchParser.parse(@q), :page => params[:page], :per_page => 2)
    
    respond_to do |format|
      format.html
      format.js {  render :template => 'dashboard/search.html.haml', :layout => nil }
    end
  end
end
