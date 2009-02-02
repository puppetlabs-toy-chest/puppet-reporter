require File.dirname(__FILE__) + '/../../spec_helper'

describe '/search/_form' do
  def do_render(locals = {})
    render :partial => '/search/form', :locals => { :q => '', :context => '' }.merge(locals)
  end
  
  it 'should include a search form' do
    do_render
    response.should have_tag('div[id=?] form[id=?]', 'search_form_container', 'search_form')
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
    
    it 'should populate the text field with the given query' do
      query = 'hairy.madstop'
      do_render :q => query
      response.should have_tag('input[name=?][value=?]', 'q', query)
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
    
    it 'should select the node choice if node context given' do
      do_render :context => 'node'
      response.should have_tag('input[type=?][name=?][value=?][checked]', 'radio', 'context', 'node')
      response.should have_tag('input[type=?][name=?][value=?]:not([checked])', 'radio', 'context', 'log')
    end
    
    it 'should select the node choice if no context given' do
      do_render
      response.should have_tag('input[type=?][name=?][value=?][checked]', 'radio', 'context', 'node')
      response.should have_tag('input[type=?][name=?][value=?]:not([checked])', 'radio', 'context', 'log')
    end
    
    it 'should select the node choice if blank context given' do
      do_render :context => ''
      response.should have_tag('input[type=?][name=?][value=?][checked]', 'radio', 'context', 'node')
      response.should have_tag('input[type=?][name=?][value=?]:not([checked])', 'radio', 'context', 'log')
    end
    
    it 'should select the log choice if log context given' do
      do_render :context => 'log'
      response.should have_tag('input[type=?][name=?][value=?][checked]', 'radio', 'context', 'log')
      response.should have_tag('input[type=?][name=?][value=?]:not([checked])', 'radio', 'context', 'node')
    end
    
    it 'should include a submit button' do
      do_render
      response.should have_tag('form[id=?]', 'search_form') do
        with_tag('input[type=?]', 'submit')
      end
    end
  end
end
