require File.dirname(__FILE__) + '/../../spec_helper'

describe '/nodes/_facts.html.erb' do
  before :each do
    @node = Node.new(:name => 'foo')
    @facts = { :operatingsystem => 'Darwin' }
    @node.stubs(:details).returns(@facts)
  end

  def do_render
    render :partial => '/nodes/facts', :locals => { :facts => @facts }
  end
  
  it 'should retrieve the list of important facts' do
    Fact.expects(:important_facts).returns([])
    do_render
  end
  
  it 'should show important facts on the view'
  it 'should use the important fact labels in the view'

  it 'should include the operatingsystem fact' do
    do_render
    response.should have_text(Regexp.new(@facts[:operatingsystem]))
  end
end
