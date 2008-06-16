require File.dirname(__FILE__) + '/../../spec_helper'

describe '/nodes/show.html.erb' do
  before :each do
    @node = Node.new(:name => 'foo')
    assigns[:node] = @node
  end
  
  def do_render
    render '/nodes/show.html.erb'
  end
  
  it 'should include the name of the Node' do
    do_render
    response.should have_text(@node.name)
  end
end