class Node
  generator_for :name, :start => 'fake node 00001' do |prev| prev.succ end
end