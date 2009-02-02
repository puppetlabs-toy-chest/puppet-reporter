class SearchParser
  class << self
    def parse(query)
      return { :name => query.split(' ').join(',') } unless query =~ /:/
      result = {}
      query.scan(/[a-z]+:\*?"[a-z ]+"\*?|[a-z]+:\*?'[a-z ]+'\*?|[a-z]+:\*?[a-z]+\*?|\*?[a-z]+\*?/) do |match|
        if match.match(/:/)
          key, str = match.split(/:/)
          result[key.to_sym] ||= []
          result[key.to_sym].push str.gsub(/['"]/, '')
        else
          result[:name] ||= []
          result[:name].push match
        end
      end
      result.keys.each { |k|  result[k] = result[k].compact.join(',') }
      result
    end
  end
end
