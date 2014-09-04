require "sources/tgz_source"

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
        parsed_json = JSON.parse(json_string)
        parsed_json.each do |time, content|
          frames[Integer(time)] = content
        end
      end
      frames
    end

    def setup
      true
    end

    def frame_at(time)
      frame = @frames[time]
      frame.is_a?(Hash) ? frame["content"] : frame
    end

    def to_s
      "<#{self.class}>"
    end
    alias :inspect :to_s

  end
end
