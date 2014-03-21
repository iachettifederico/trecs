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

      create_frame
    end

    def record
      start
      perform_recording
      finish
    end

    private
    attr_reader :step
    attr_accessor :recording

    def start
      self.current_time = nil
      self.recording = true
      start_recording
    end

    def finish
      finish_recording
      self.recording = false
    end

    def create_frame
    end

    def perform_recording
    end
  end
end
