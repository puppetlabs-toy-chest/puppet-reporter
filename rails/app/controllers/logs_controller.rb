class LogsController < ApplicationController
  def recent
    @logs = Log.recent
  end
end
