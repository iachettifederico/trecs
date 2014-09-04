require "strategies/strategy"
module TRecs
  class RawFileStrategy
    include Strategy
    attr_reader :file

    def initialize(options={})
      file  = options.fetch(:input_file)
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
        current_time(timestamp(clock.now - start_time))
        current_content(File.read(@file))
        save_frame

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
