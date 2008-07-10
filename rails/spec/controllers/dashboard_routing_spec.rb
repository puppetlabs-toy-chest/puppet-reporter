require File.dirname(__FILE__) + '/../spec_helper'

describe DashboardController, "#route_for" do

  it "should map { :controller => 'dashboard', :action => 'index' } to /" do
    route_for(:controller => "dashboard", :action => "index").should == "/"
  end
end

describe DashboardController, "#params_from" do
  
  it "should generate params { :controller => 'dashboard', action => 'index' } from GET /dashboard/index" do
    params_from(:get, "/dashboard/index").should == {:controller => "dashboard", :action => "index"}
  end
  
  it "should generate params { :controller => 'dashboard', action => 'index' } from GET /dashboard" do
    params_from(:get, "/dashboard").should == {:controller => "dashboard", :action => "index"}
  end
  
  it "should generate params { :controller => 'dashboard', action => 'index' } from GET /" do
    params_from(:get, "/").should == {:controller => "dashboard", :action => "index"}
  end
end
