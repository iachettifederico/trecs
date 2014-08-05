require 'json'
require "fileutils"
require "zlib"
require 'archive/tar/minitar'
require "tmpdir"
require "pathname"
require "yaml"

module TRecs
  class TgzSource
    include Archive::Tar

    attr_reader :trecs_file

    def initialize(options={})
      @trecs_file = options.fetch(:trecs_file)
      #FileUtils.rm(trecs_file, force: true)
    end

    def create_recording
      in_tmp_dir do
        @tgz = Zlib::GzipWriter.new(File.open(trecs_file, 'wb'))

        yield self

        create_file('manifest.yaml') do |f|
          f.write manifest.to_yaml
        end

        Minitar.pack(@files_to_add.flatten, @tgz)
      end
    end

    def read_recording
      frames = {}
      in_tmp_dir do
        tgz = Zlib::GzipReader.new(File.open(trecs_file, 'rb'))
        Minitar.unpack(tgz, "./")
        json_string = File.read("frames.json")
        parsed_json = JSON.parse(json_string)
        parsed_json.each do |time, content|
          frames[Integer(time)] = content
        end
      end
      frames
    end
    
    def in_tmp_dir
      Dir.mktmpdir("trecs_record") do |dir|
        Dir.chdir(dir) do
          yield
        end
      end
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

    def []=(key, value)
      manifest[key.to_s] = value
    end
    
    private

    def manifest
      @manifest ||= {}
    end

  end
end
