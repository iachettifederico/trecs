require "sources/tgz_source"

module TRecs
  class JsonReader
    attr_accessor :player
    attr_reader :frames
    attr_reader :timestamps
    attr_reader :source

    def initialize(options={})
      trecs_file = options.fetch(:trecs_file)
      @source  = options.fetch(:source)
      @frames = get_frames
      @timestamps = @frames.keys
    end

    def get_frames
      frames = {}
      source.read do
        json_string = source.read_file("frames.json")
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
      @frames[time]
    end

    def to_s
      "<#{self.class}>"
    end
    alias :inspect :to_s

  end
end
