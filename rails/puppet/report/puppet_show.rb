require 'puppet/reports'

def connection_settings
  { :host => 'localhost', :port => 80 }
end

def submit_yaml_report_to_puppetshow(report)
  network_post report.to_yaml
end

def network_post(data)
  network {|conn| conn.post("/nodes/create", data).body }
end

def network(&block)
  Net::HTTP.start(connection_settings[:host], connection_settings[:port]) {|conn| yield(conn) }
end


Puppet::Reports.register_report(:puppet_show) do
  Puppet.settings.use(:reporting)
  desc "Send report information to PuppetShow"

  def process
    submit_yaml_report_to_puppetshow(self)
  end
end