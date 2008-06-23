class ReportsController < ApplicationController
  skip_before_filter :verify_authenticity_token  
  
  def show
    @report = Report.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = 'Could not find information for that report.'
    return redirect_to(reports_path)
  end
  
  def create
    return render(:text => 'report YAML is required', :status => 500) unless params[:report]
    Report.from_yaml(params[:report])
    render(:text => "Report successfully created at #{Time.zone.now}")
  rescue Exception => e
    render(:text => "Error processing request: [#{e}]", :status => 500)
  end
end
