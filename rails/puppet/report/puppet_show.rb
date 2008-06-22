require 'puppet/reports'

def submit_yaml_report_to_puppetshow(yaml)
  lookup_connection_settings
end

def lookup_connection_settings
end

Puppet::Reports.register_report(:puppet_show) do
  Puppet.settings.use(:reporting)
  desc "Send report information to PuppetShow"

  def process
    # do a net/htpp post to URL with data of self.to_yaml
  end
end

