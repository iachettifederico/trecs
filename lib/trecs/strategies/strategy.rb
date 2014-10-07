module TRecs
  module Strategy
    attr_accessor :recorder

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
      options = {time: __time, format: __format, content: __content}
      options.reject! {|k,v| v.nil?}

      recorder.current_frame(options)
    end
  end
end
