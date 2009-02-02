class SearchParser
  class << self
    WILDCARD = /\*?/
    VALUE = /[a-z]+/
    WILD_VALUE = /#{WILDCARD}#{VALUE}#{WILDCARD}/
    WORDS = /#{VALUE}(?: #{VALUE})*/
    DQUOTED = /"#{WORDS}"/
    SQUOTED = /'#{WORDS}'/
    QUOTED  = /#{DQUOTED}|#{SQUOTED}/
    KEYWORD = VALUE
    KEYVALUE = /#{VALUE}|#{QUOTED}/
    WILD_KEYVALUE = /#{WILDCARD}#{KEYVALUE}#{WILDCARD}/
    KEYPAIR = /#{KEYWORD}:#{WILD_KEYVALUE}/
    SEGMENT = /#{KEYPAIR}|#{WILD_VALUE}/
    
    def parse(query)
      result = Hash.new { |h, k|  h[k] = [] }
      
      if query.match(/:/)
        query.scan(SEGMENT) do |match|
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
