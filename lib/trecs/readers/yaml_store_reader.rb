require 'yaml/store'

module TRecs
  class YamlStoreReader
    attr_accessor :player
    attr_reader :frames
    attr_reader :file


    def initialize(options={})
      @file = options.fetch(:file)
      File.open(@file)
    end

    def setup
      store = YAML::Store.new "/tmp/hola.trecs"
      @frames = store.transaction do
        store["frames"]
      end
    end

    def frame_at(time)
      @frames[time]
    end
  end
end
