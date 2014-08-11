require "spec_helper"
require "recording_strategies/config_strategy"
require "recorder"
require "recording_strategies/hash_strategy"
require "writers/in_memory_writer"

module TRecs
  describe ConfigStrategy do
    context "options" do

      context "set values" do

        Given(:options) {
          {
            step: 40,
            format: "yaml_store",
            strategies: [],
            spureous_option: "something spureous",
          }
        }

        Given(:strategy) { ConfigStrategy.new(options) }

        Then { strategy.step == 40 }
        Then { strategy.format == "yaml_store" }
        Then { strategy.strategies == [] }
      end

      context "default values" do
        Given(:strategy) { ConfigStrategy.new }

        Then { strategy.step == 100 }
        Then { strategy.format == "json" }
        Then { strategy.strategies == [] }
      end
    end

    context "strategies" do
      context "adding strategies" do
        Given(:strategy) { ConfigStrategy.new(strategies: [first_strategy]) }
        Given(:first_strategy) { Object.new }
        Given(:second_strategy) { Object.new }
        Given(:third_strategy) { Object.new }

        context "just one" do
          Then { strategy.strategies == [first_strategy] }
        end

        context "adding later" do
          context "one by one" do
            When { strategy << second_strategy }
            When { strategy << third_strategy }

            Then { strategy.strategies == [
                first_strategy,
                second_strategy,
                third_strategy,
              ] }
          end

          context "in bulk" do
            When { strategy.append(second_strategy, third_strategy) }

            Then { strategy.strategies == [
                first_strategy,
                second_strategy,
                third_strategy,
              ] }
          end
        end

        context "#perform" do
          Given(:writer)   { InMemoryWriter.new }
          Given(:recorder) { Recorder.new(strategy: strategy, writer: writer) }

          When { strategy.recorder = recorder }
          When { recorder.record }

          context "one strategy" do
            Given(:s) { HashStrategy.new(
                {
                  0   => "A",
                  100 => "B",
                  200 => "C",
                }
                ) }

            Given(:strategy) { ConfigStrategy.new(strategies: [s]) }

            Then { writer.frames[0]   == "A" }
            Then { writer.frames[100] == "B" }
            Then { writer.frames[200] == "C" }
          end

          context "two strategies" do
            Given(:s1) { HashStrategy.new(
                {
                  0  => "A",
                  10 => "B",
                  20 => "C",
                }
                )
            }

            Given(:s2) { HashStrategy.new(
                {
                  0  => "D",
                  15 => "E",
                  30 => "F",
                }
                )
            }

            Given(:strategy) { ConfigStrategy.new(strategies: [s1, s2]) }

            Then { writer.frames[0]   == "A" }
            Then { writer.frames[10]  == "B" }
            Then { writer.frames[20]  == "C" }

            Then { writer.frames[120] == "D" }
            Then { writer.frames[135] == "E" }
            Then { writer.frames[150] == "F" }
          end

        end
      end
    end
  end
end
