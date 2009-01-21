require File.dirname(__FILE__) + '/../../spec_helper'

describe '/dashboard/index' do
  before :each do
    @log = Log.generate!(:source => 'log source')
    assigns[:logs] = [@log]
  end
  
  def do_render
    render '/dashboard/index'
  end
  
  it 'should include content' do
    do_render
    response.should have_tag('div[id=?]', 'content')
  end
  
  it 'should include a search form' do
    do_render
    response.should have_tag('div[id=?] form[id=?]', 'search', 'search_form')
  end
  
  describe 'search form' do
    it 'should submit to the dashboard search action' do
      do_render
      response.should have_tag('form[id=?][action=?]', 'search_form', search_path)
    end
    
    it 'should use HTTP GET when submitting' do
      do_render
      response.should have_tag('form[id=?][method=?]', 'search_form', 'get')
    end
    
    it 'should include a text field for entering search terms' do
      do_render
      response.should have_tag('form[id=?]', 'search_form') do
        with_tag('input[name=?][type=?]', 'q', 'text')
      end
    end
    
    it 'should include a choice to search for nodes' do
      do_render
      response.should have_tag('form[id=?]', 'search_form') do
        with_tag('input[type=?][name=?][value=?]', 'radio', 'context', 'node')
      end
    end
    
    it 'should include a choice to search for logs' do
      do_render
      response.should have_tag('form[id=?]', 'search_form') do
        with_tag('input[type=?][name=?][value=?]', 'radio', 'context', 'log')
      end
    end
    
    it 'should include a submit button' do
      do_render
      response.should have_tag('form[id=?]', 'search_form') do
        with_tag('input[type=?]', 'submit')
      end
    end
  end

  it 'should include a region for displaying search results' do
    do_render
    response.should have_tag('div[id=?]', 'search_results_container')
  end
end
