require File.dirname(__FILE__) + '/../../spec_helper'

describe '/dashboard/index' do
  def do_render
    render '/dashboard/index'
  end
  
  it 'should exist' do
    do_render
  end
end
