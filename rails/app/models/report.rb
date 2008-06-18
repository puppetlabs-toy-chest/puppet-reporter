class Report < ActiveRecord::Base
  belongs_to :node
  
  def self.import_from_yaml_files(files)
    good, bad = [], []
    files.each do |file|
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
end
