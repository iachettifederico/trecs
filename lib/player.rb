require_relative "timestamps"


module TRecs
  class Player
    attr_reader :output

    def initialize(time: nil, step: 100, output: $stdout, **options)
      @current_time = time
      @step         = step
      @ticks        = time ? Array(time.to_i) : ticks
      @output       = output
    end

    def tick(time=current_time)
      self.current_time = time
      get_frame(time)
    end

    def timestamps
      @timestamps ||= get_timestamps.sort
    end

    def generate_ticks
      ticks = [0]
      curr  = 0
      while(curr < timestamps.last.to_i)
        curr += step
        ticks << curr
      end
      ticks
    end

    def ticks
      @ticks ||= generate_ticks
    end

    private
    attr_accessor :current_time
    attr_reader :step

    def time_at(time)
      Timestamps.new(timestamps).time_at(time)
    end

    def get_timestamps
      []
    end
  end
end
