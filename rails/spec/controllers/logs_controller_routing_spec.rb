require File.dirname(__FILE__) + '/../spec_helper'

describe LogsController, "#route_for" do
  it "should map { :controller => 'logs', :action => 'recent' } to /logs/recent" do
    route_for(:controller => "logs", :action => "recent").should == "/logs/recent"
  end
end

describe LogsController, "#params_from" do
  it "should generate params { :controller => 'logs', action => 'recent' } from GET /logs/recent" do
    params_from(:get, "/logs/recent").should == {:controller => "logs", :action => "recent"}
  end
end
