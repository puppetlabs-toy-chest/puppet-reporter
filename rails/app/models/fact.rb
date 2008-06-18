class Fact < ActiveRecord::Base
  belongs_to :node
  serialize :values
  
  before_save :default_timestamp_to_now
  before_save :default_values_to_empty
  
  def default_timestamp_to_now
    self.timestamp ||= Time.now
  end
  private :default_timestamp_to_now
  
  def default_values_to_empty
    self.values ||= {}
  end
  private :default_values_to_empty
  
  def self.refresh_for_node(node)
    require 'puppet' unless defined? Puppet
    Puppet::Node::Facts.terminus_class = :yaml
    facts = Puppet::Node::Facts.find(node.name)
    raise RuntimeError, "unable to locate facts for node [#{node.name}]" unless facts
    Fact.new(:values => facts)
  end
  
  def self.important_facts
    [
      { :key => 'ipaddress',                  :label => 'IP Address' },
      { :key => 'fqdn',                       :label => 'FQDN' },
      { :key => 'hostname',                   :label => 'Hostname' },
      { :key => 'domain',                     :label => 'Domain' },
      { :key => 'kernel',                     :label => 'Kernel' },
      { :key => 'operatingsystem',            :label => 'Operating System' },
      { :key => 'operatingsystemrelease',     :label => 'OS Release' },
      { :key => 'sp_os_version',              :label => 'OS Version' },
      { :key => 'sp_kernel_version',          :label => 'Kernel Version' },
      { :key => 'sp_cpu_type',                :label => 'CPU' },
      { :key => 'hardwaremodel',              :label => 'Hardware Model' },
      { :key => 'sp_number_processors',       :label => '# Processors' },      
      { :key => 'sp_current_processor_speed', :label => 'Processor Speed' },
      { :key => 'macaddress',                 :label => 'MAC Address' },
      { :key => 'sp_bus_speed',               :label => 'Bus Speed' },
      { :key => 'sp_physical_memory',         :label => 'Physical Memory' },
      { :key => 'puppetversion',              :label => 'Puppet Version' },
      { :key => 'rubyversion',                :label => 'Ruby Version' },
      { :key => 'facterversion',              :label => 'Facter Version' },
    ]
  end
end
