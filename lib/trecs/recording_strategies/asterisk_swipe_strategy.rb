require "recording_strategies/strategy"
require "recording_strategies/hash_strategy"
require "recording_strategies/shell_command_strategy"

module TRecs
  class AsteriskSwipeStrategy < HashStrategy
    include Strategy
    include ShellCommandStrategy
    attr_reader :message
    attr_reader :step

    def initialize(options={})
      @message = options.fetch(:message)
      @step = options.fetch(:step) { 100 }
      @command = options.fetch(:command) { nil }
      @frames = {}
    end

    def perform
      max_line_size = message.each_line.inject(0) { |max, l| l.size > max ? l.size : max  }

      message.each_line do |line|
        curr_message = " %-#{max_line_size}s  " % line.chomp
        (0..(curr_message.length-1)).each do |i|
          current_time = step.to_i * i

          c = curr_message.dup
          c[i] = "|"
          (i+1..c.length-3).each do |j|
            c[j] = "*"
          end
          c = c[1..-2]
          @frames[current_time] = "" unless @frames[current_time]
          @frames[current_time] = @frames[current_time] << c.strip + "\n"
        end
      end
      @frames.each do |t, c|
        @frames[t] = @frames[t].chomp
      end
      super
    end
  end
end


# ****
# ****
#
# |***
# |***
#
#
# h|**
# c|**
#
# ho|*
# ch|*
#
# hol|
# cha|
#
# hola|
# chau|
#
# hola|
# chau|
