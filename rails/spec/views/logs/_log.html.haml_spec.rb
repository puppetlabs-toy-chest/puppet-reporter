require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/logs/_log" do
  before(:each) do
    @log = Log.generate!(:level => 'info', :message => 'hiya!', :source => 'yermom', :timestamp => Time.now)
  end

  def do_render
    render :partial => 'logs/log', :object => @log
  end

  describe 'log item' do
    it 'should include log level' do
      do_render
      response.should have_tag('tr', :text => Regexp.new(Regexp.escape(@log.level), true))
    end

    it 'should be classed with log level' do
      do_render
      response.should have_tag('tr[class=?]', "log_#{@log.level}")
    end

    it 'should include log message' do
      do_render
      response.should have_tag('tr', :text => Regexp.new(Regexp.escape(@log.message)))
    end

    it 'should include log source' do
      do_render
      response.should have_tag('tr', :text => Regexp.new(Regexp.escape(@log.source)))
    end

    it 'should include log time' do
      do_render
      response.should have_tag('tr', :text => Regexp.new(Regexp.escape(@log.timestamp.to_s)))
    end

    describe 'when log has tags' do
      before :each do
        @tags = 'basenode, main, os::darwin'
        @log.stubs(:tag_names).returns(@tags)
      end

      it 'should include the log tags' do
        do_render
        response.should have_tag('tr', :text => Regexp.new(Regexp.escape(@tags)))
      end
    end

    describe 'when log has no tags' do
      before :each do
        @log.stubs(:tag_names).returns('')
      end

      it 'should not include any tag information for the log' do
        do_render
        response.should_not have_tag('tr', :text => Regexp.new(/tags:/))
      end
    end
  end
end
