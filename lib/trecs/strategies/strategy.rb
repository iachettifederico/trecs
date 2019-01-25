require "frame"
module TRecs
  class Strategy
    attr_accessor :recorder
    attr_accessor :offset
    attr_accessor :step

    def initialize(options={})
      @step = options.fetch(:step) { 100 }
    end
    
    def write_frames_to(writer)
      perform
      writer.render_frames(frames)
    end

    def frames
      @frames ||= {}
    end

    def stop
    end

    private

    attr_accessor :__time
    attr_accessor :__content
    attr_accessor :__format

    def current_time(time=nil)
      if time
        @__time = time
      end
      @__time
    end

    def current_content(content=nil)
      if content
        @__content = content
      end
      @__content
    end

    def current_format(format=nil)
      if format
        @__format = format
      end
      @__format
    end

    def save_frame
      frames[__time] = Frame.new(content: __content, format: __format)
    end
  end
end
