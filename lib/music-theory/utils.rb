class CyclicArray < Array
  def [](index)
    super(index % size)
  end

  def []=(index, value)
    super(index % size, value)
  end

  def map(&block)
    self.class.new(super)
  end
end
