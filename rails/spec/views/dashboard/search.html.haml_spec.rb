require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/dashboard/search" do
  before :each do
    @query = assigns[:q] = 'query'
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
      response.should have_tag('div[id=?]', 'search_results') do
        with_tag('div', /No.*found/)
      end
    end

    it 'should include the original query string' do
      do_render
      response.should have_tag('div[id=?]', 'search_results') do
        with_tag('div', Regexp.new(@query))
      end
    end
  end

  describe 'when there are results' do
    before :each do
      @results = assigns[:results] = Array.new(3) { Node.generate! }
    end

    it 'should restate the original query string' do
      do_render
      response.should have_tag('div[id=?]', 'search_results') do
        with_tag('div', Regexp.new(@query))
      end
    end

    it 'should show each search result' do
      do_render
      response.should have_tag('div[id=?]', 'search_results') do
        @results.each_with_index do |node,i|
          with_tag('div[id=?]', "result-#{i}")
        end
      end
    end

    it 'should include each node name' do
      do_render
      response.should have_tag('div[id=?]', 'search_results') do
        @results.each do |node|
          with_tag('div', Regexp.new(node.name))
        end
      end
    end
    
    it 'should include a link to each node' do
      do_render
      response.should have_tag('div[id=?]', 'search_results') do
        @results.each do |node|
          with_tag('div a[href=?]', node_path(node))
        end
      end      
    end
  end
end
