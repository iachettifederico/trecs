require 'yaml/store'

module TRecs
  class YamlStoreReader
    attr_accessor :player
    attr_reader :frames
    attr_reader :file
    attr_reader :timestamps

    def initialize(options={})
      @file = options.fetch(:file)
      File.open(@file)

      store = YAML::Store.new "/tmp/hola.trecs"
      @frames = store.transaction do
        store["frames"]
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
