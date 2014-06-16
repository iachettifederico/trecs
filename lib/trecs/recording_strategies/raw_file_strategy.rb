require "recording_strategy"
module TRecs
  class RawFileStrategy
    attr_accessor :recorder
    attr_reader :file

    def initialize(options={})
      file  = options.fetch(:file)
      @file = File.open(file)

      @clock   = options.fetch(:clock) { Time }
      @testing = options.fetch(:testing) { false }
      #
      #@height = options.fetch(:height) { 24  }
      #@width  = options.fetch(:width)  { 80  }
      #
    end

    def perform
      @recording = true
      start_time = clock.now

      while @recording
        time    = timestamp(clock.now - start_time)
        content = File.read(@file)
        recorder.current_frame(time: time, content: content)
        custom_sleep(recorder.step)
      end
    end

    def custom_sleep(millis)
      if testing
        clock.sleep(millis)
      else
        @sleep_time ||= (millis/1000.0)
        sleep(@sleep_time)
      end
    end

    def stop
      @recording = false
    end

    private
    attr_reader :clock
    attr_reader :testing



    def timestamp(time)
      (time * 1000).to_i
    end
  end
end
