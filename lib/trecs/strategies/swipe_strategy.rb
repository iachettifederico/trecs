require "strategies/strategy"
require "strategies/hash_strategy"
require "strategies/shell_command_strategy"

module TRecs
  class SwipeStrategy < Strategy
    include ShellCommandStrategy
    attr_reader :message

    def initialize(options={})
      super(options)
      @message = options.fetch(:message)
      @command = options.fetch(:command) { nil }
      @swiper  = options.fetch(:swiper)  { "|" }
      @hider   = options.fetch(:hider)   { "*" }
      @frames  = {}
    end

    def perform
      message.each_line do |line|
        curr_message = " %-#{max_line_size}s  " % line.chomp
        curr_message.length.times do |i|
          current_time = step.to_i * i

          c = curr_message.dup
          c[i] = swiper
          (i+1..c.length-3).each do |j|
            c[j] = hider
          end
          c = c[1..-2]
          @frames[current_time] ||= ""
          @frames[current_time] << c.strip + "\n"
        end
      end

      cleanup_frames
    end

    private
    attr_reader :swiper
    attr_reader :hider

    def cleanup_frames
      @frames.each do |t, c|
        @frames[t] = @frames[t].chomp
      end
    end

    def max_line_size
      message.each_line.inject(0) { |max, l| l.size > max ? l.size : max  }
    end
  end
end
