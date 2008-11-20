# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'mocha'
require 'spec'
require 'spec/rails'

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end

# disable model observers
Dir.glob File.join(RAILS_ROOT, 'app', 'observers', '*.rb') do |file|
  File.basename(file, '_observer.rb').camelize.constantize.delete_observers  
end

Dir[File.dirname(__FILE__) + '/shared_behaviors/*_behavior.rb'].collect do |f|
  File.expand_path(f)
end.each do |file|
  require file
end

require File.expand_path(File.dirname(__FILE__) + '/custom_matchers')

Spec::Runner.configure do |config|
  config.include ThinkingSphinxIndexMatcher
end

def report_yaml
  '--- !ruby/object:Puppet::Transaction::Report 
    host: phage.madstop.com
    logs: 
      - !ruby/object:Puppet::Util::Log 
        level: :err
        message: "Failed to retrieve current state of resource: cannot convert nil into String"
        objectsource: true
        source: //basenode/puppetclient/remotefile[/etc/puppet/puppet.conf]/File[/etc/puppet/puppet.conf]
        tags: 
          - :basenode
          - :main
          - :puppetclient
          - :remotefile
          - :file
          - :source
        time: 2007-05-31 17:05:52.188748 -05:00
      - !ruby/object:Puppet::Util::Log 
        level: :notice
        message: executed successfully
        objectsource: true
        source: //basenode/os::darwin/Exec[/bin/echo yaytest]/returns
        tags: 
          - :basenode
          - :main
          - :os::darwin
          - :exec
          - :testing
          - :returns
        time: 2007-05-31 17:05:53.698169 -05:00
    metrics: 
      time: !ruby/object:Puppet::Util::Metric 
        label: Time
        name: time
        values: 
          - 
            - :filebucket
            - Filebucket
            - 0.000102043151855469
          - 
            - :notify
            - Notify
            - 0.000590801239013672
          - 
            - :total
            - Total
            - 2.97548842430115
          - 
            - :exec
            - Exec
            - 0.011544942855835
          - 
            - :schedule
            - Schedule
            - 0.000103950500488281
          - 
            - :config_retrieval
            - Config retrieval
            - 0.150889158248901
          - 
            - :user
            - User
            - 0.124068021774292
          - 
            - :file
            - File
            - 2.68818950653076
      resources: !ruby/object:Puppet::Util::Metric 
        label: Resources
        name: resources
        values: 
          - 
            - :restarted
            - Restarted
            - 0
          - 
            - :applied
            - Applied
            - 1
          - 
            - :failed_restarts
            - Failed restarts
            - 0
          - 
            - :total
            - Total
            - 29
          - 
            - :skipped
            - Skipped
            - 0
          - 
            - :failed
            - Failed
            - 1
          - 
            - :scheduled
            - Scheduled
            - 23
          - 
            - :out_of_sync
            - Out of sync
            - 2
      changes: !ruby/object:Puppet::Util::Metric 
        label: Changes
        name: changes
        values: 
          - 
            - :total
            - Total
            - 2
    records: {}
    time: 2007-05-31 17:05:53.824906 -05:00
    '
end
