module TRecs
  class ClockTicker
    attr_accessor :player
    attr_reader :delayer
    attr_reader :from
    attr_reader :to

    def initialize(options={})
      @delayer = options.fetch(:delayer) { Kernel }
      @timestamps = options.fetch(:timestamps) { nil }
      @from = options.fetch(:from) { nil }
      @to   = options.fetch(:to)   { nil }
    end

    def start
      prev_time = 0
      timestamps.each do |time|
        player.tick(time)
        delayer.sleep((time - prev_time)/1000.0)
        prev_time = time
      end
      true
    end

    def timestamps
      @timestamps ||= player.timestamps
      if from
        @timestamps = @timestamps.select { |t| t > from }
        @timestamps.unshift(from)
      end
      if to && to > 0
        @timestamps = @timestamps.select { |t| t < to }
        @timestamps.push(to)
      end
      @timestamps
    end

    def to_s
      "<#{self.class}>"
    end
    alias :inspect :to_s
  end
end
