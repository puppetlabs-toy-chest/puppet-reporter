require File.dirname(__FILE__) + '/../../spec_helper'

describe '/layouts/application' do
  def do_render
    render '/layouts/application'
  end
  
  it 'should include juggernaut JS' do
    do_render
    response.should have_text(/juggernaut\.js/)
  end
  
  it 'should include flot JS' do
    do_render
    response.should have_text(/jquery\.flot\.js/)
  end
end
