require 'json'
require "fileutils"

module TRecs
  class JsonWriter
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
      
      File.open(file, File::CREAT|File::TRUNC|File::RDWR, 0644) do |f|
        f.write(json_string)
      end
    end
  end
end
