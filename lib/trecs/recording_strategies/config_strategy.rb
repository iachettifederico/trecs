require "recording_strategies/strategy"

module TRecs
  class ConfigStrategy
    include Strategy
    attr_reader :step
    attr_reader :format
    attr_reader :strategies

    def initialize(options={})
      @step       = options.fetch(:step)       { 100 }
      @format     = options.fetch(:format)     { "json" }
      @strategies = options.fetch(:strategies) { [] }
    end

    def <<(strategies)
      Array(strategies).each do |strategy|
        @strategies << strategy
      end
    end

    def perform
      strategies.each do |strategy|
        strategy.recorder = recorder
        strategy.perform
        recorder.offset = recorder.next_timestamp
      end
    end

  end
end
