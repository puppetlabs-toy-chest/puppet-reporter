require 'puppet/reports'

def submit_yaml_report_to_puppetshow(report)
  network.post report.to_yaml
end

# TODO:  untested -- derived from main Puppet REST code
def network_post(data)
  network {|conn| conn.post("/nodes/create", data).body }
end

# TODO:  untested -- derived from main Puppet REST code
def network(&block)
  Net::HTTP.start(connection_settings[:host], connection_settings[:port]) {|conn| yield(conn) }
end

def connection_settings
  { :host => 'localhost', :port => 80 }
end

Puppet::Reports.register_report(:puppet_show) do
  Puppet.settings.use(:reporting)
  desc "Send report information to PuppetShow"

  def process
    submit_yaml_report_to_puppetshow(self)
  end
end

