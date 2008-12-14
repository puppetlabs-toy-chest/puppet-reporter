class SearchParser
  class << self
    def parse(query)
      return { :name => query } unless query =~ /:/
      result, name = { }, []
      query.scan(/[a-z]+:"[a-z ]+"|[a-z]+:'[a-z ]+'|[a-z]+:[a-z]+|[a-z]+/).each do |match|
        if match =~ /(.*):["']?([^'"]*)["']?/
          result[$1.to_sym] = $2
        else
          name << match
        end
      end
      result[:name] = (name << result[:name]).compact.join(' ') unless name.empty?
      result
    end
  end
end
