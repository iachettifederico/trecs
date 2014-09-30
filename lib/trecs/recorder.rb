module TRecs
  class Recorder
    attr_reader :writer
    attr_reader :strategy
    attr_reader :step
    attr_reader :recording
    attr_reader :current_time
    attr_reader :current_content

    attr_accessor :offset

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
      do_record do
        writer.setup
        strategy.perform
        writer.render
      end
    end

    def current_frame(options={})
      @current_time    = options.fetch(:time) { next_timestamp }
      @current_content = options.fetch(:content)

      if @previous_content != current_content
        new_current_time  = current_time + offset
        options[:time] = new_current_time
        writer.create_frame(options)
        @previous_content = current_content
      end
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

    def do_record
      self.current_time = nil
      self.recording    = true
      yield
      self.recording    = false
    end

  end
end
