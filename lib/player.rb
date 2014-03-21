require "timestamps"
require "terminal_screen"

module TRecs
  class Player
    attr_reader :output

    def initialize(time: nil, step: 100, output: TerminalScreen.new, testing: false, **options)
      @current_time = time
      @step         = step
      @ticks        = time ? Array(time.to_i) : ticks
      @output       = output
      @testing      = testing
    end

    def play
      ticks.each do |time|
        play_frame(time)
        sleep(sleep_time) unless testing
      end
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

    def play_frame(time)
      output.clear_screen
      output.puts tick(time)
    end

    private
    attr_accessor :current_time
    attr_reader   :step
    attr_reader   :testing

    def time_at(time)
      Timestamps.new(timestamps).time_at(time)
    end

    def get_timestamps
      []
    end

    def sleep_time
      # TODO: Fix this to use the current time
      @sleep_time ||= (step/1000.0)*0.8
    end
  end
end
