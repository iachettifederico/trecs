require "frame"
module TRecs
  module Strategy
    attr_accessor :recorder
    attr_accessor :offset

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
      frames[__time] = Frame.new(format: __format, content: __content)
    end
  end
end
