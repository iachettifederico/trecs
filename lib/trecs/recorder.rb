module TRecs
  class Recorder
    attr_reader :writer
    attr_reader :strategy
    attr_reader :step
    attr_reader :recording
    attr_reader :current_time
    attr_reader :current_content

    attr_reader :offset

    def initialize(options={})
      @writer            = options.fetch(:writer)
      @writer.recorder   = self

      @strategy          = options.fetch(:strategy)
      @strategy.recorder = self

      @step   = options.fetch(:step)   { 100 }
      @offset = options.fetch(:offset) { 0 }

      @recording    = false
      @current_time = nil
    end

    def record
      self.current_time = nil
      self.recording    = true
      strategy.write_frames_to(writer)
      self.recording    = false
    end

    def next_timestamp
      @current_time = -step unless @current_time
      @current_time += step
    end

    def stop
      strategy.stop
    end

    private

    attr_writer :recording
    attr_writer :current_time
    attr_writer :current_content
  end
end
