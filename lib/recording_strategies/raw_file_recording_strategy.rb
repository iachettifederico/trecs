require "recording_strategy"
module TRecs
  class RawFileRecordingStrategy < RecordingStrategy
    def initialize(options)
      file = options.fetch(:file) 
      raise "File does not exist: #{file}" unless File.exist?(file)
      @file = File.new(file)
      
      @height = options.fetch(:height) { 24  }
      @width  = options.fetch(:width)  { 80  }
      @step   = options.fetch(:step)   { 100 }

      super
    end

    def perform
      @recording = true
      start_time = Time.now

      while @recording
        time    = timestamp(Time.now - start_time)
        content = File.read(@file)
        recorder.current_frame(time: time, content: content)
        sleep(sleep_time)
      end
    end

    def stop
      @recording = false
    end

    private
    def sleep_time
      # TODO: Fix this to use the current time
      @sleep_time ||= (@step/1000.0)
    end

    def timestamp(time)
      (time * 1000).to_i
    end
  end
end
