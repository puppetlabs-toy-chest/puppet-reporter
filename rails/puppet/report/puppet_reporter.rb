require 'puppet'

module PuppetReporterReportHelpers
  def connection_settings
    { :host => 'localhost', :port => 3000 }
  end

  def submit_yaml_report_to_puppetshow(report)
    network_post report.to_yaml
  end

  def network_post(data)
    network {|conn| conn.post("/reports/create", 'report=' + CGI.escape(data)).body }
  end
  
  def network(&block)
    Net::HTTP.start(connection_settings[:host], connection_settings[:port]) {|conn| yield(conn) }
  end
end

Puppet::Reports.register_report(:puppet_reporter) do
  Puppet.settings.use(:reporting)
  desc "Send report information to Puppet-Reporter"

  def process
    self.class.send(:include, PuppetReporterReportHelpers)
    self.submit_yaml_report_to_puppetshow(self)
  rescue Exception => e
    File.open('/tmp/report_testing_output.txt', 'w') {|f| f.puts e.to_s }
  end
end
