require "sources/tgz_source"
require "frame"

module TRecs
  class JsonReader
    attr_accessor :player
    attr_reader :frames
    attr_reader :timestamps
    attr_reader :source

    def initialize(options={})
      @source = options.fetch(:source) {
        trecs_backend = options.fetch(:trecs_backend)
        TgzSource.new(trecs_backend: trecs_backend)
      }
      @frames = get_frames
      @timestamps = @frames.keys
    end

    def get_frames
      frames = {}
      source.read do
        json_string = source.read_entry("frames.json") || "{}"
        parsed_json = JSON.parse(json_string, symbolize_names: true)
        parsed_json.each do |time, value|
          frames[Integer(time.to_s)] = TRecs::Frame(value)
        end
      end
      frames
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
