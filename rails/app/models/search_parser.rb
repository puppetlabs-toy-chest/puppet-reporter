class SearchParser
  class << self
    def parse(query)
      return { :name => query } unless query =~ /:/
      result, name = { }, []
      query.scan(/[a-z]+:\*?"[a-z ]+"\*?|[a-z]+:\*?'[a-z ]+'\*?|[a-z]+:\*?[a-z]+\*?|\*?[a-z]+\*?/) do |match|
        if match.match(/:/)
          key, str = match.split(/:/)
          result[key.to_sym] = str.gsub(/['"]/, '')
        else
          name << match
        end
      end
      result[:name] = (name << result[:name]).compact.join(' ') unless name.empty?
      result
    end
  end
end
