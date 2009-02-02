require File.dirname(__FILE__) + '/../../spec_helper'

describe '/layouts/application' do
  def do_render
    render '/layouts/application'
  end
  
  it 'should include flot JS' do
    do_render
    response.should have_text(/jquery\.flot\.js/)
  end
  
  it 'should include the search form' do
    template.expects(:render).with(:partial => '/search/form')
    do_render
  end
end
