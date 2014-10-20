require "strategies/strategy"
require "writers/in_memory_writer"

module TRecs
  class ConfigStrategy < Strategy
    attr_reader :format
    attr_reader :strategies

    def initialize(options={})
      super(options)
      
      @format     = options.fetch(:format)     { "json" }
      @strategies = options.fetch(:strategies) { [] }
      @offset     = options.fetch(:offset)     { 0 }

      @writer = InMemoryWriter.new

    end

    def <<(strategy)
      @strategies << strategy
    end

    def append(*strategies)
      strategies.each do |strategy|
        self << strategy
      end
    end

    def perform
      current_time(0)
      strategies.each do |strategy|
        strategy.write_frames_to(@writer)
        strategy.frames.each do |time, frame|
          current_content(frame.content)
          current_format(frame.format)
          current_time(time + offset)
          save_frame
        end
        self.offset = current_time + self.step
      end
      
    end

  end
end
