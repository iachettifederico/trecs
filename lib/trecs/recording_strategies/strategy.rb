module TRecs
  module Strategy
    attr_accessor :recorder

    def stop
    end

    private

    attr_accessor :__time
    attr_accessor :__content

    def current_time(time)
      @__time = time
    end

    def current_content(content)
      @__content = content
    end

    def save_frame
      recorder.current_frame(time: __time, content: __content)
    end
  end
end
