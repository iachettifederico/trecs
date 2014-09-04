require "strategies/strategy"
module TRecs
  class FileFramesStrategy
    include Strategy
    attr_accessor :frames

    def initialize(dirname)
      @frames = Dir.entries(dirname)
        .select { |d| d =~ /\d+/}
        .each_with_object(Hash.new) do |filename, h|
        h[filename.to_i] = File.read(dirname + "/" + filename)
      end
    end

    def perform
      @frames.each do |time, content|
        current_time(time)
        current_content(content)
        save_frame
      end
    end

    def stop
    end

    def inspect
      "<#{self.class}: frames: #{frames}>"
    end
  end
end
