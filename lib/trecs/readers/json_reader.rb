require 'json'
require "pathname"

module TRecs
  class JsonReader
    attr_accessor :player
    attr_reader :frames
    attr_reader :file
    attr_reader :timestamps

    def initialize(options={})
      @file = options.fetch(:trecs_file)
      json_string = File.read(@file)
      @frames = {}
      parsed_json = JSON.parse(json_string)
      parsed_json.each do |time, content|
        @frames[Integer(time)] = content
      end
      
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
