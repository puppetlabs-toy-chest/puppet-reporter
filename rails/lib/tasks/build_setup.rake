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
end
