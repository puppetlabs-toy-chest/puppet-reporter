require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/dashboard/search" do
  before :each do
    @query = assigns[:q] = 'query'
    template.stubs(:will_paginate)
  end

  def do_render
    render '/dashboard/search'
  end

  it 'should include search results' do
    do_render
    response.should have_tag('div[id=?]', 'search_results')
  end
  
  describe 'when there are no results' do
    before :each do
      @results = assigns[:results] = []
    end

    it 'should show a no search results message' do
      do_render
      response.should have_tag('div[id=?]', 'search_results', /No.*found/)
    end

    it 'should include the original query string' do
      do_render
      response.should have_tag('div[id=?]', 'search_results', Regexp.new(Regexp.escape(@query)))
    end
  end

  describe 'when there are results' do
    before :each do
      @result = Node.generate!
      assigns[:results] = [@result]
    end

    it 'should restate the original query string' do
      do_render
      response.should have_tag('div[id=?]', 'search_results', Regexp.new(Regexp.escape(@query)))
    end

    it 'should have a container for the search result' do
      do_render
      response.should have_tag('div[id=?]', 'search_results') do
        with_tag('div')
      end
    end
    
    it 'should have give the result container an ID' do
      do_render
      response.should have_tag('div[id=?]', 'search_results') do
        with_tag('div[id=?]', 'result-0')
      end
    end
    
    it 'should include the node name in the result container' do
      do_render
      response.should have_tag('div[id=?]', 'search_results') do
        with_tag('div[id=?]', 'result-0', Regexp.new(Regexp.escape(@result.name)))
      end
    end
    
    it 'should link to the node name in the result container' do
      do_render
      response.should have_tag('div[id=?]', 'search_results') do
        with_tag('div[id=?]', 'result-0') do
          with_tag('a[href=?]', node_path(@result))
        end
      end
    end
    
    it 'should have a container for each result' do
      other_result = Node.generate!
      results = assigns[:results] = [@result, other_result]
      do_render
      response.should have_tag('div[id=?]', 'search_results') do
        results.each_with_index do |result, i|
          with_tag('div[id=?]', "result-#{i}", Regexp.new(Regexp.escape(result.name)))
        end
      end
    end

    it 'should paginate results' do
      template.expects(:will_paginate)
      do_render
    end
  end
end
