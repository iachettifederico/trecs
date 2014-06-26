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
        current_time(time)
        current_content(content)
        save_frame
      end
    end

    def stop
    end
  end
end
