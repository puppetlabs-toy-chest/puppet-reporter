module ThinkingSphinxIndexMatcher
  class HaveIndex
    def initialize(expected)
      @expected = expected
    end
    
    def matches?(target)
      @target = target
      target.sphinx_indexes.collect(&:fields).flatten.collect(&:columns).flatten.collect(&:__name).include?(@expected)
    end
    
    def failure_message
      "expected #{@target} to index #{@expected}"
    end
    
    def negative_failure_message
      "expected #{@target} not to index #{@expected}, but did"
    end
  end
  
  def have_index(expected)
    HaveIndex.new(expected)
  end
end
