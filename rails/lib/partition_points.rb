class Range
  def partition_points(interval)
    points = []
    
    point = first
    while point <= last
      points.push(point)
      point += interval
    end
    points.push(last) unless points.include?(last)
    
    points 
  end
  
  def partitions(interval)
    partition_points(interval).enum_for(:each_cons, 2).to_a
  end
end
