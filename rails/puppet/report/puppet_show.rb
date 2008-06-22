require 'puppet/reports'

Puppet::Reports.register_report(:puppet_show) do
  Puppet.settings.use(:reporting)
  desc "Send report information to PuppetShow"

  def process
    # do a net/htpp post to URL with data of self.to_yaml
  end
end

