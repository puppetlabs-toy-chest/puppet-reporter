require File.dirname(__FILE__) + '/../../spec_helper'

describe '/layouts/application' do
  def do_render
    render '/layouts/application'
  end
  
  it 'should include flot JS' do
    do_render
    response.should have_text(/jquery\.flot\.js/)
  end
  
  it 'should include the search form, passing search parameters' do
    query = 'hairy.mad.stop'
    context = 'log'
    params[:q] = query
    params[:context] = context
    
    template.expects(:render).with(:partial => '/search/form', :locals => { :q => query, :context => context})
    do_render
  end
end
