class LogObserver < ActiveRecord::Observer
  def controller
    returning ActionController::Base.new do |controller|
      controller.instance_variable_set('@template', ActionView::Base.new(ActionController::Base.view_paths))
      controller.instance_variable_set('@assigns', {})
    end
  end
  
  def after_create(log)
    controller.render :juggernaut do |page|
      page.insert_html :after, 'dashboard_logs_top', :partial => 'logs/log', :locals => { :log => log }
    end
  end
end
