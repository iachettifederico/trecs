# -*- coding: utf-8 -*-
require 'json'
require "fileutils"
require "zlib"
require 'archive/tar/minitar'
require "tmpdir"
require "pathname"
require "yaml"

#module TRecs
#  class TgzSource
#    include Archive::Tar
#
#    def initialize(options={})
#      @trecs_backend = options.fetch(:trecs_backend)
#    end
#
#    def create_recording
#      in_tmp_dir do
#        @tgz = Zlib::GzipWriter.new(trecs_backend)
#
#        yield self if block_given?
#
#        create_entry('manifest.yaml') do |f|
#          f.write manifest.to_yaml
#        end
#
#        Minitar.pack(@files_to_add.flatten, @tgz)
#      end
#    end
#
#    # TODO: Este es el punto de intersección entre read y create_recording
#    def manifest
#      @manifest ||= {}
#    end
#
#    def []=(key, value)
#      manifest[key] = value
#    end
#
#    def [](key)
#      manifest[key]
#    end
#
#    def read_file(file_name)
#      File.read(file_name)
#    end
#
#    def create_entry(file_name)
#      File.open(file_name, File::CREAT|File::TRUNC|File::RDWR, 0644) do |f|
#        yield f
#      end
#      add_file(file_name)
#    end
#
#    def add_file(file_name)
#      @files_to_add ||= []
#      @files_to_add << file_name
#    end
#
#    def add_audio_file(file_name)
#      Dir.mkdir("audio") unless File.exist? "audio"
#
#      orig_file = file_name
#      file_name = "./audio/" + Pathname(file_name).basename.to_s
#      FileUtils.symlink(orig_file, file_name)
#      add_file(file_name)
#    end
#
#    private
#
#    attr_reader :trecs_backend
#
#    #Investigar como hacer para descomprimir en memoria
#    def in_tmp_dir
#      Dir.mktmpdir("trecs_record") do |dir|
#        Dir.chdir(dir) do
#          yield
#        end
#      end
#    end
#  end
#end
#

module TRecs
  class TgzSource
    include Archive::Tar

    attr_reader :trecs_backend
    attr_reader :audio_files

    def initialize(options={})
      @trecs_backend = options.fetch(:trecs_backend)
    end

    def create_recording
      in_tmp_dir do
        @tgz = Zlib::GzipWriter.new(File.open(trecs_backend, 'wb'))

        yield self

        create_file('manifest.yaml') do |f|
          f.write manifest.to_yaml
        end

        Minitar.pack(@files_to_add.flatten, @tgz)
      end
    end

    def read
      in_tmp_dir do
        tgz = Zlib::GzipReader.new(File.open(trecs_backend, 'rb'))
        Minitar.unpack(tgz, "./")

        yield self
      end
    end

    def build_reader(options={})
      reader = nil
      options[:source] = self
      read do |source|
        @manifest = YAML.load(source.read_file("manifest.yaml"))

        format = manifest["format"]
        reader_file = "readers/#{format}_reader"
        require reader_file
        reader_class_name = [
          "TRecs::",
          format.split(/[-_\s]/).map(&:capitalize),
          "Reader"
        ].join
        reader_class = reader_class_name.split("::").reduce(Object) { |a, e| a.const_get e }
        reader = reader_class.new(options)
      end
      reader
    end

    # Investigar como hacer para descomprimir en memoria
    def in_tmp_dir
      Dir.mktmpdir("trecs_record") do |dir|
        Dir.chdir(dir) do
          yield
        end
      end
    end

    def read_file(file_name)
      File.read(file_name)
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

    # TODO: Este es el punto de intersección entre read y create_recording
    def manifest
      @manifest ||= {}
    end

  end
end
