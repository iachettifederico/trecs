require 'json'
require "fileutils"
require "zlib"
require 'archive/tar/minitar'
require "tmpdir"


module TRecs
  class JsonWriter
    include Archive::Tar

    attr_accessor :recorder

    attr_reader :frames
    attr_reader :file
    attr_reader :audio_files

    def initialize(options={})
      @file        = options.fetch(:trecs_file)
      @audio_files = options.fetch(:audio_files) { [] }
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

      in_tmp_dir do
        tgz = Zlib::GzipWriter.new(File.open(file, 'wb'))
        File.open("frames.json", File::CREAT|File::TRUNC|File::RDWR, 0644) do |f|
          f.write json_string
        end

        Minitar.pack('frames.json', tgz)
      end
    end

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
