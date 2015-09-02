class Array
  def avg(n=size)
    return nil if n == 0
    compact.sum / n
  end
end