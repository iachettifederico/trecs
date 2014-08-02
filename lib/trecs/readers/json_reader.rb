require 'json'
require "pathname"
require 'zlib'
require 'archive/tar/minitar'

module TRecs
  class JsonReader
    include Archive::Tar

    attr_accessor :player
    attr_reader :frames
    attr_reader :file
    attr_reader :timestamps

    def initialize(options={})
      @file = options.fetch(:trecs_file)

      temp_file_name = "/tmp/trecs/" + Time.now.to_i.to_s + @file.gsub(/[\/\.]/, "-")
      tgz = Zlib::GzipReader.new(File.open(@file, 'rb'))
      Minitar.unpack(tgz, temp_file_name)
      json_string = File.read(temp_file_name + "/frames.json")

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
