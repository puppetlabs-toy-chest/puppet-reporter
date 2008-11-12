require 'fileutils'

desc 'Prepare for automated build'
task :build_setup do
  FileUtils.copy(File.join(RAILS_ROOT, 'config', 'database.yml.example'), 
                 File.join(RAILS_ROOT, 'config', 'database.yml')) 
  FileUtils.copy(File.join(RAILS_ROOT, 'config', 'juggernaut.yml.example'), 
                 File.join(RAILS_ROOT, 'config', 'juggernaut.yml')) 
  FileUtils.copy(File.join(RAILS_ROOT, 'config', 'juggernaut_hosts.yml.example'), 
                 File.join(RAILS_ROOT, 'config', 'juggernaut_hosts.yml')) 
  FileUtils.copy(File.join(RAILS_ROOT, 'spec', 'spec.opts.example'), 
                 File.join(RAILS_ROOT, 'spec', 'spec.opts')) 

  # vendor puppet for testing
  `cd #{RAILS_ROOT}/vendor; rm -rf puppet; git clone git://reductivelabs.com/puppet`

  # as well as facter
  `cd #{RAILS_ROOT}/vendor; rm -rf facter; git clone git://reductivelabs.com/facter`

  # and ensure that our vendored versions are what is used
  File.open(File.join(RAILS_ROOT, 'config', 'puppet_lib.rb'), 'w') do |f|
    f.puts <<-"EOF"
      # Note:  facter is required by puppet so it must come first
      FACTER_LIB ='#{File.join(RAILS_ROOT, 'vendor', 'facter', 'lib')}'
      $:.unshift(FACTER_LIB)
      require 'facter'

      PUPPET_LIB ='#{File.join(RAILS_ROOT, 'vendor', 'puppet', 'lib')}'
      $:.unshift(PUPPET_LIB)
      require 'puppet'
    EOF
  end
end
