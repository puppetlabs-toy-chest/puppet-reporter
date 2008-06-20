class Node
  generator_for :name, :start => 'fake node '+Time.now.to_i.to_s do |prev| prev.succ end
end