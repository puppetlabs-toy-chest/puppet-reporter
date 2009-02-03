require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LogsHelper, 'display_log_message' do
  it 'should be' do
    helper.should respond_to(:display_log_message)
  end

  it 'should accept a log message argument' do
    lambda { helper.display_log_message('msg') }.should_not raise_error(ArgumentError)
  end

  it 'should complain if missing a log message argument' do
    lambda { helper.display_log_message() }.should raise_error(ArgumentError)
  end
  
  it 'should return one div if the message is under 100 chars' do
    msg = '*' * 99
    helper.display_log_message(msg).should have_tag('div', 1)
  end

  it 'should not return a show more link if the message is under 100 chars' do
    msg = '*' * 99
    helper.display_log_message(msg).should_not have_tag('a')
  end

  it 'should return two divs if the message is over 100 chars' do
    msg = '*' * 101
    helper.display_log_message(msg).should have_tag('div', 2)
  end

  it 'should return a show more link if the message is over 100 chars' do
    msg = '*' * 101
    helper.display_log_message(msg).should have_tag('a')
  end
end
