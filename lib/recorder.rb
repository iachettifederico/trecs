module TRecs
  class Recorder
    attr_writer :current_time

    def initialize(step: 100, **options)
      @step         = step

    end

    def next_timestamp
      @current_time = -step unless @current_time
      @current_time += step
    end

    def current_time(time=nil)
      if time
        @current_time = time
      end
      @current_time
    end

    def current_content(content=nil)
      if content
        @current_content = content
      end
      @current_content
    end

    def current_frame(time: next_timestamp, content:)
      current_time(time)
      current_content(content)

      if previous_content != content
        create_frame
        self.previous_content = content
      end
    end

    def record
      start
      perform_recording
      finish
    end

    private
    attr_reader :step
    attr_accessor :recording
    attr_accessor :previous_content

    def start
      self.current_time = nil
      self.recording = true
      setup
    end

    def finish
      render
      self.recording = false
    end

    def create_frame
    end

    def perform_recording
    end
  end
end
