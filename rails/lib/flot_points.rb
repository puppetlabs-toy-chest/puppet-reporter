class Array
  def flot_points
    enum_for(:each_with_index).to_a.collect(&:reverse)
  end
end
