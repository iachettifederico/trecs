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
      if content != @prev_content
        screen.clear
        screen.puts(content)
        @prev_content = content
      end
    end

    private
    attr_writer :current_time
    attr_reader   :testing

  end
end


# require "timestamps"
# require "screens/terminal_screen"

# module TRecs
#   class Player
#     attr_reader :screen

#     def initialize(options={})
#       time = options.fetch(:time) { nil }
#       @current_time = time
#       @step         = options.fetch(:step) { 100 }
#       @screen       = options.fetch(:screen) { TerminalScreen.new }
#       @testing      = options.fetch(:testing) { false }
#       @ticks        = time ? Array(time.to_i) : ticks
#     end

#     def play
#       ticks.each do |time|
#         play_frame(time)
#         sleep(sleep_time) unless testing
#       end
#     end

#     def tick(time=current_time)
#       self.current_time = time
#       get_frame(time)
#     end

#     def timestamps
#       @timestamps ||= get_timestamps.sort
#     end

#     def generate_ticks
#       ticks = [0]
#       curr  = 0
#       while(curr < timestamps.last.to_i)
#         curr += step
#         ticks << curr
#       end
#       ticks
#     end

#     def ticks
#       @ticks ||= generate_ticks
#     end

#     def play_frame(time)
#       screen.clear
#       screen.puts tick(time_at(time))
#     end

#     def time_at(time)
#       Timestamps.new(timestamps).time_at(time)
#     end

#     private
#     attr_accessor :current_time
#     attr_reader   :step
#     attr_reader   :testing



#     def get_timestamps
#       []
#     end

#     def get_frame(time)
#       ""
#     end

#     def sleep_time
#       # TODO: Fix this to use the current time
#       @sleep_time ||= (step/1000.0)*0.8
#     end
#   end
# end
