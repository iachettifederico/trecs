module TRecs
  class InMemoryWriter
    attr_accessor :recorder
    attr_reader :frames

    def setup
      @frames = {}
    end

    def create_frame(options={})
      time = options.fetch(:time)
      content = options.fetch(:content)
      @frames[time] = content
    end

    def render_frames(frames)
      @frames = frames
    end
  end
end
