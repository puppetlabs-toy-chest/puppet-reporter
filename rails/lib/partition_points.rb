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
    points = partition_points(interval)
    partitions = []
    points.each_cons(2) { |points|  partitions.push(points) }
    partitions
  end
end
