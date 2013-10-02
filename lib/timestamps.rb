class Timestamps
  attr_reader :collection

  def initialize(collection)
    @collection = collection
  end

  def time_at(time=0)
    time = time.to_s.to_i
    return 0 if collection.empty?
    return collection.first  if time <= collection.first
    return collection.last   if time >= collection.last
    collection.each_cons(2) do |a, b|
      if b == time
        return b
      end
      if b > time
        return a
      end
    end
  end
end
