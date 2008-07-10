require File.dirname(__FILE__) + '/../../spec_helper'

describe '/dashboard/index.html.erb' do
  def do_render
    render '/dashboard/index.html.erb'
  end
  
  it 'should include content' do
    do_render
    response.should have_tag('div[id=?]', 'content')
  end
  
  it 'should include node status'
  it 'should include logs'
  it 'should include a log tag cloud'
end
