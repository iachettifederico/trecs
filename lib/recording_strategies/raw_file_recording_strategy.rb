require "recording_strategy"
module TRecs
  class RawFileRecordingStrategy < RecordingStrategy
    def initialize(file:, height: 24, width: 80, step: 100, **options)
      raise "File does not exist: #{file}" unless File.exist?(file)
      @file = File.new(file)
      @step = step
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
