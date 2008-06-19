class MetricsController < ApplicationController
  def show
    @metric = Metric.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:notice] = 'Could not find information for that metric.'
    return redirect_to(metrics_path)
  end
end
