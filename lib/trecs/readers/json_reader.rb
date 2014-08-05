require "sources/tgz_source"

module TRecs
  class JsonReader
    attr_accessor :player
    attr_reader :frames
    attr_reader :timestamps

    def initialize(options={})
      trecs_file = options.fetch(:trecs_file)
      source  = TgzSource.new(trecs_file: trecs_file)
      @frames = source.read_recording

      @timestamps = @frames.keys
    end

    def setup
      true
    end

    def frame_at(time)
      @frames[time]
    end

    def to_s
      "<#{self.class}>"
    end
    alias :inspect :to_s

  end
end
