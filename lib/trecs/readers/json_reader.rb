require 'json'
require "pathname"
require 'zlib'
require 'archive/tar/minitar'
require "tmpdir"

module TRecs
  class JsonReader
    include Archive::Tar

    attr_accessor :player
    attr_reader :frames
    attr_reader :file
    attr_reader :timestamps

    def initialize(options={})
      @file = options.fetch(:trecs_file)
      @frames = {}

      in_tmp_dir do
        tgz = Zlib::GzipReader.new(File.open(@file, 'rb'))
        Minitar.unpack(tgz, "./")
        json_string = File.read("frames.json")
        parsed_json = JSON.parse(json_string)
        parsed_json.each do |time, content|
          @frames[Integer(time)] = content
        end

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

    private
    def in_tmp_dir
      Dir.mktmpdir("trecs_record") do |dir|
        Dir.chdir(dir) do
          yield
        end
      end
    end
  end
end
