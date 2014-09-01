require "recording_strategies/strategy"
require "recording_strategies/hash_strategy"

module TRecs
  class AsteriskSwipeStrategy < HashStrategy
    include Strategy
    attr_reader :text
    attr_reader :step

    def initialize(options={})
      @text = options.fetch(:text)
      @step = options.fetch(:step) { 100 }
      @frames = {}
    end

    def perform
      max_line_size = text.each_line.inject(0) { |max, l| l.size > max ? l.size : max  }

      text.each_line do |line|
        curr_text = " %-#{max_line_size}s  " % line.chomp
        (0..(curr_text.length-1)).each do |i|
          current_time = step * i

          c = curr_text.dup
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
