require "recording_strategies/strategy"
module TRecs
  class HashStrategy
    include Strategy
    attr_accessor :frames

    def initialize(frames={})
      @frames = frames || Hash.new
    end

    def perform
      @frames.each do |time, content|
        if time.is_a?(Numeric) || /\A\d+\Z/ === time
          current_time(time.to_s.to_i)
          current_content(content)
          save_frame
        end
      end
    end

    def stop
    end

    def inspect
      "<#{self.class}: frames: #{frames}>"
    end
  end
end
