require 'json'
require "fileutils"
require "zlib"
require 'archive/tar/minitar'
require "tmpdir"
require "pathname"
require "yaml"

module TRecs
  class JsonWriter
    include Archive::Tar

    attr_accessor :recorder

    attr_reader :frames
    attr_reader :file
    attr_reader :audio_files
    attr_reader :manifest

    def initialize(options={})
      @file        = options.fetch(:trecs_file)
      @audio_files = options.fetch(:audio_files) { [] }
      @audio_files = Array(@audio_files)
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
      in_tmp_dir do
        @tgz = Zlib::GzipWriter.new(File.open(file, 'wb'))

        # From here

        json_string = frames.to_json

        create_file('frames.json') do |f|
          f.write json_string
        end

        
        # To here

        create_file('manifest.yaml') do |f|
          f.write manifest.to_yaml
        end

        audio_files.each do |file|
          add_audio_file(file)
        end

        Minitar.pack(@files_to_add.flatten, @tgz)
      end
    end

    private

    def manifest
      @manifest ||= {
        "format" => self.class.to_s[/\ATRecs::(\w+)Writer\Z/, 1].downcase
      }
    end

    def create_file(file_name)
      File.open(file_name, File::CREAT|File::TRUNC|File::RDWR, 0644) do |f|
        yield f
      end
      add_file(file_name)
    end

    def add_file(file_name)
      @files_to_add ||= []
      @files_to_add << file_name
    end

    def add_audio_file(file_name)
      Dir.mkdir("audio") unless File.exist? "audio"

      orig_file = file_name
      file_name = "./audio/" + Pathname(file_name).basename.to_s
      FileUtils.symlink(orig_file, file_name)
      add_file(file_name)
    end

    def in_tmp_dir
      Dir.mktmpdir("trecs_record") do |dir|
        Dir.chdir(dir) do
          yield
        end
      end
    end
  end
end
