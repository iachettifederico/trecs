require "spec_helper"
require "strategies/config_strategy"
require "strategies/hash_strategy"
require "recorder"

module TRecs
  describe ConfigStrategy do
    context "options" do
      context "set values" do
        Given(:options) {
          {
            step:            40,
            format:          "json",
            strategies:      [],
            spureous_option: "something spureous",
          }
        }

        Given(:strategy) { ConfigStrategy.new(options) }

        Then { strategy.step       == 40 }
        Then { strategy.format     == "json" }
        Then { strategy.strategies == [] }
      end

      context "default values" do
        Given(:strategy) { ConfigStrategy.new }

        Then { strategy.step       == 100 }
        Then { strategy.format     == "json" }
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

##### Creo que esto va aca
### context "Offset" do
###   context "initialization" do
###     context "from constructor" do
###       Given(:recorder) { Recorder.new(offset: 10, writer: OpenStruct.new, strategy: OpenStruct.new) }
###       Then { recorder.offset == 10 }
###     end
###
###     context "setter" do
###       Given(:recorder) { Recorder.new(offset: 10, writer: OpenStruct.new, strategy: OpenStruct.new) }
###       When { recorder.offset =  30 }
###       Then { recorder.offset == 30 }
###     end
###   end
###
###   Given   { Spy.clear }
###   Given(:writer)   { Spy.new("Writer").ignore(:recorder=, :setup, :render) }
###   Given(:strategy) { CustomStrategy.new }
###
###   Given(:recorder) {
###     Recorder.new(offset: 7, writer: writer, strategy: strategy, step: 10)
###   }
###
###   When {
###     strategy.action = -> {
###       recorder.current_frame(time: 0,  content: "CONTENT")
###       recorder.current_frame(time: 10, content: "CONTENT 2")
###       recorder.current_frame(time: 12, content: "CONTENT 3")
###       recorder.current_frame(          content: "CONTENT 4")
###     }
###     recorder.record
###   }
###
###   Then {
###     writer.calls[1] == [
###       :create_frame,
###       [ { time: 7, content: "CONTENT" } ]
###     ]
###   }
###   Then {
###     writer.calls[2] == [
###       :create_frame,
###       [ { time: 17, content: "CONTENT 2" } ]
###     ]
###   }
###   Then {
###     writer.calls[3] == [
###       :create_frame,
###       [ { time: 19, content: "CONTENT 3" } ]
###     ]
###   }
###   Then { recorder.current_time == 22 }
###   Then {
###     writer.calls[4] == [
###       :create_frame,
###       [ { time: 29, content: "CONTENT 4" } ]
###     ]
###   }
### end
