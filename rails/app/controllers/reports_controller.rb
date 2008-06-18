class ReportsController < ApplicationController
  def show
    @report = Report.find(params[:id])
  end

end
