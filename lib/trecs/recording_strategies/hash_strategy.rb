class HashStrategy
  attr_accessor :recorder
  attr_accessor :frames

  def initialize(frames)
    @frames = frames || Hash.new
  end

  def perform
    @frames.each do |time, content|
      recorder.current_frame(time: time, content: content)
    end
  end

  def stop
  end
end
