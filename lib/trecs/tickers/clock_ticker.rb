module TRecs
  class ClockTicker
    attr_accessor :player
    attr_reader :delayer
    attr_reader :from
    attr_reader :to
    attr_reader :speed

    def initialize(options={})
      @delayer = options.fetch(:delayer) { Kernel }
      @timestamps = options.fetch(:timestamps) { nil }
      @from  = options.fetch(:from)  { nil }
      @to    = options.fetch(:to)    { nil }
      @speed = options.fetch(:speed) { 1 }
    end

    def start
      prev_time = timestamps.first
      timestamps.each do |time|
        sleep(time - prev_time)
        player.tick(time)
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

    private

    def sleep(time)
      sleep_time =  time / (1000.0 * speed)
      delayer.sleep(sleep_time)
    end
  end
end
