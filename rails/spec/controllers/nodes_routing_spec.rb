require File.dirname(__FILE__) + '/../spec_helper'

describe NodesController, "#route_for" do

  it "should map { :controller => 'nodes', :action => 'show', :id => 1 } to /nodes/1" do
    route_for(:controller => "nodes", :action => "show", :id => 1).should == "/nodes/1"
  end
end

describe NodesController, "#params_from" do
  
  it "should generate params { :controller => 'nodes', action => 'show', id => '1' } from GET /nodes/1" do
    params_from(:get, "/nodes/1").should == {:controller => "nodes", :action => "show", :id => "1"}
  end
end
