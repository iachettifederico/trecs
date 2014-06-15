module TRecs
  class Recorder
    attr_reader :writer
    attr_reader :strategy
    attr_reader :step
    attr_reader :recording
    attr_reader :current_time
    attr_reader :current_content


    def initialize(options={})
      @writer   = options.fetch(:writer)
      @writer.recorder = self

      @strategy = options.fetch(:strategy)
      @strategy.recorder = self

      @step = options.fetch(:step) { 100 }
      @recording = false
      @current_time = nil
    end

    def record
      self.current_time = nil
      self.recording = true
      writer.setup
      strategy.perform
      writer.render
      self.recording = false
    end

    def current_frame(options={})
      time = options.fetch(:time) { next_timestamp }
      content = options.fetch(:content)
      @current_time = time
      @current_content = content

      if @previous_content != content
        writer.create_frame(time: current_time, content: current_content)
        @previous_content = content
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

  end
end
