class Report < ActiveRecord::Base
  serialize :details
  
  belongs_to :node
  
  delegate :logs, :to => :details
  
  # create Report instances from files containing Puppet YAML reports
  def self.import_from_yaml_files(filenames)
    good, bad = [], []
    filenames.each do |file|
      begin
        Report.from_yaml File.read(file)
        good << file
      rescue SystemCallError => e
        warn "Could not read file [#{file}]: #{e}"
        bad << file
      rescue Exception => e
        warn "There was an error processing file [#{file}]: #{e}"
        bad << file
      end
    end
    [ good, bad ]
  end
  
  # create a single Report instance from a Puppet report YAML string
  def self.from_yaml(yaml)
    thawed = YAML.load(yaml)
    node = (Node.find_by_name(thawed.host) || Node.create!(:name => thawed.host))
    Report.create!(:details => yaml, :timestamp => thawed.time, :node => node)
  end
end
