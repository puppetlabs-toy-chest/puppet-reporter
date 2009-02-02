class SearchParser
  class << self
    def parse(query)
      result = Hash.new { |h, k|  h[k] = [] }
      
      if query.match(/:/)
        query.scan(/[a-z]+:\*?"[a-z ]+"\*?|[a-z]+:\*?'[a-z ]+'\*?|[a-z]+:\*?[a-z]+\*?|\*?[a-z]+\*?/) do |match|
          key = :name
          if match.match(/:/)
            key, str = match.split(/:/)
            key   = key.to_sym
            match = str.gsub(/['"]/, '')
          end
          result[key].push match
        end
      else
        result[:name] = query.split(' ')
      end
      
      result.keys.each { |k|  result[k] = result[k].compact.join(',') }
      result
    end
  end
end
