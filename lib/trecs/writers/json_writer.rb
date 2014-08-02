require 'json'
require "fileutils"
require "zlib"
require 'archive/tar/minitar'


module TRecs
  class JsonWriter
    include Archive::Tar

    attr_accessor :recorder
    attr_reader :frames
    attr_reader :file

    def initialize(options={})
      @file = options.fetch(:trecs_file)
      FileUtils.rm(@file, force: true)
    end

    def setup
      @frames = {}
    end

    def create_frame(options={})
      time = options.fetch(:time)
      content = options.fetch(:content)
      frames[time] = content
    end

    def render
      json_string = frames.to_json

      Dir.chdir("/tmp/") do
        tgz = Zlib::GzipWriter.new(File.open(file, 'wb'))
        File.open("frames.json", File::CREAT|File::TRUNC|File::RDWR, 0644) do |f|
          f.write json_string
        end

        Minitar.pack('frames.json', tgz)
      end
    end
  end
end
