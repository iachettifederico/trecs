require 'yaml/store'
require "fileutils"

module TRecs
  class YamlStoreWriter
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
      @frames[time] = content
    end

    def render
      store = YAML::Store.new file
      store.transaction do
        store["frames"] = @frames
      end
    end
  end
end
