CustomStrategy = Struct.new(:recorder, :action) do
  def perform
    self.action.call
  end
end
