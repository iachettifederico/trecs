require "fileutils"
module TRecs
  class WatchFileTicker
    attr_accessor :player
    def initialize(opts={})
      @watch_file = opts.fetch(:ticker_file)
      FileUtils.touch(@watch_file)
      File.open(@watch_file, "w") do |f|
        f.write("0")
      end
      @step = opts.fetch(:step)
    end

    def start
      while input =~ /\A[0-9]+\Z/
        time = input.to_i
        player.tick(time)
        sleep(@step/1000.0)
      end
    end
    def to_s
      "<#{self.class}>"
    end
    alias :inspect :to_s
    private
    def input
      File.read(@watch_file).chomp
    end
  end
end
