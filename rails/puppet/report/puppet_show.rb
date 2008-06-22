require 'puppet/reports'

Puppet::Reports.register_report(:inspect) do
    Puppet.settings.use(:reporting)
    desc "Just inspect a report record"

    def process
      File.open('/tmp/bullshit.txt', 'w') do |f|
	f.puts to_yaml
        f.puts
 	f.puts methods.collect{|m| ":#{m}"}.sort.join(", ")
        f.puts
	f.puts inspect
        f.puts
	f.puts "host: " + host
        f.puts
        f.puts "metrics:"
        f.puts metrics.inspect
        f.puts
        f.puts "metrics yaml: "
        f.puts metrics.to_yaml
        f.puts
        @metrics = nil
        f.puts inspect
      end
    end
end

