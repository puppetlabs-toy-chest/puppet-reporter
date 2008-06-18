class Report < ActiveRecord::Base
  belongs_to :node
  
  def self.import_from_yaml_files(files)
    files.each do |file|
      begin
        Report.from_yaml File.read(file)
      rescue Errno::ENOENT => e
        warn "Could not read file [#{file}]: #{e}"
      end
    end
  end
end
