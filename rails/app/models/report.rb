class Report < ActiveRecord::Base
  belongs_to :node
  
  def self.import_from_yaml_files(files)
    files.each do |file|
      Report.from_yaml File.read(file)
    end
  end
end
