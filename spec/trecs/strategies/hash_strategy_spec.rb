require "spec_helper"
require "strategies/hash_strategy"

module TRecs
  describe HashStrategy do
    context "initialization" do
      When(:strategy1) { HashStrategy.new({}) }
      Then { strategy1.frames == {} }

      When(:strategy2) { HashStrategy.new }
      Then { strategy2.frames == {} }
    end

    context "recorder" do
      Given(:strategy) { HashStrategy.new }
      Given(:recorder) { Object.new }
      When { strategy.recorder = recorder }
      Then { strategy.recorder == recorder }
    end

    context "perform" do
      Given(:writer)   { InMemoryWriter.new }
      Given(:strategy) { IncrementalStrategy.new(message: "Hello World") }
      Given(:recorder) { Recorder.new(strategy: strategy, writer: writer) }

      Given(:strategy) { HashStrategy.new(
          {
            0         => "A",
            10.0      => "B",
            "15"      => "C",
            "1a2b3C4" => "h",
            20        => "D",
            :"25"     => "E",
          }
          ) }

      When { strategy.recorder = recorder }
      When { recorder.record }
      When { strategy.perform }

      Then { writer.frames[0]  ==  "A" }
      Then { writer.frames[10] ==  "B" }
      Then { writer.frames[15] ==  "C" }
      Then { writer.frames[20] ==  "D" }
      Then { writer.frames[25] ==  "E" }
    end
  end
end
