xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"

xml.data do
  @reports.sort_by(&:timestamp).each do |report|
    xml.event(
              :start => report.timestamp.strftime("%b %d %Y %H:%M:%S GMT-0500"), 
              :title => "#{report.node.name} -- #{report.timestamp.strftime("%m/%d/%Y @ %H:%M:%S")}",
              :link  => report_path(report))
  end
end