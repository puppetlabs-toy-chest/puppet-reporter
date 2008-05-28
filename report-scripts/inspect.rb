require 'puppet/reports'

Puppet::Reports.register_report(:inspect) do
    Puppet.settings.use(:reporting)
    desc "Just inspect a report record"

    def process
      File.open('/tmp/bullshit.txt', 'w') do |f|
	f.puts self.to_yaml

 	f.puts self.methods.collect{|m| ":#{m}"}.sort.join(", ")
	
	f.puts self.inspect

	f.puts "host: " + self.host
      end
    end
end

