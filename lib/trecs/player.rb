require "screens/terminal_screen"

module TRecs
  class Player
    attr_reader :reader
    attr_reader :screen
    attr_reader :ticker
    attr_reader :step
    attr_reader :current_time

    def initialize(options={})
      time = options.fetch(:time) { nil }
      @reader        = options.fetch(:reader)
      @reader.player = self

      @ticker        = options.fetch(:ticker)
      @ticker.player = self

      @screen       = options.fetch(:screen) { TerminalScreen.new }

      @testing      = options.fetch(:testing) { false }

      @current_time = time
      @step         = options.fetch(:step) { 100 }
    end

    def play
      reader.setup
      ticker.start
    end

    def tick(time=current_time)
      content = reader.frame_at(time)
      if content != prev_content
        screen.clear
        screen.puts(content)
        self.prev_content = content
      end
    end

    def timestamps
      @timestamps ||= reader.timestamps
    end

    def time_to_play(time)
      time = time.to_i
      return time if timestamps.include? time
      result = timestamps.each_cons(2).select do |min, max|
        time > min && time < max
      end
      result = result.first
      result ? result.first : timestamps.last
    end

    private
    attr_writer :current_time
    attr_reader :testing
    attr_accessor :prev_content

  end
end
