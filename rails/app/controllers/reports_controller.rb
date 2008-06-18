class ReportsController < ApplicationController
  def show
    @report = Report.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = 'Could not find information for that report.'
    return redirect_to(reports_path)
  end
end
