require "spec_helper"
require "strategies/swipe_strategy"

require "recorder"
require "strategies/hash_strategy"
require "writers/in_memory_writer"

module TRecs
  describe SwipeStrategy do
    skip("Modify Swipe")
    #context "initialization" do
    #  When(:strategy) { SwipeStrategy.new }
    #  Then { expect(strategy).to have_raised(/key not found.*message/) }
    #end
    #
    #context "performing" do
    #  Given(:writer)   { InMemoryWriter.new }
    #  Given(:recorder) { Recorder.new(strategy: strategy, writer: writer) }
    #
    #  When { strategy.recorder = recorder }
    #  When { recorder.record }
    #  When { strategy.perform }
    #
    #  context "one char" do
    #    Given(:strategy) { SwipeStrategy.new(message: "a") }
    #    Then { writer.frames[0]   == "*" }
    #    Then { writer.frames[100] == "|" }
    #    Then { writer.frames[200] == "a|" }
    #    Then { writer.frames[300] == "a" }
    #  end
    #
    #  context "two chars" do
    #    Given(:strategy) { SwipeStrategy.new(message: "ab", step: 10) }
    #    Then { writer.frames[0]  == "**" }
    #    Then { writer.frames[10] == "|*" }
    #    Then { writer.frames[20] == "a|" }
    #    Then { writer.frames[30] == "ab|" }
    #    Then { writer.frames[40] == "ab" }
    #  end
    #
    #  context "multiple_lines" do
    #    Given(:strategy) { SwipeStrategy.new(message: "FIRST\nSECOND") }
    #    Then { writer.frames[0]   == "******\n******" }
    #    Then { writer.frames[100] == "|*****\n|*****" }
    #    Then { writer.frames[200] == "F|****\nS|****" }
    #    Then { writer.frames[300] == "FI|***\nSE|***" }
    #    Then { writer.frames[400] == "FIR|**\nSEC|**" }
    #    Then { writer.frames[500] == "FIRS|*\nSECO|*" }
    #    Then { writer.frames[600] == "FIRST|\nSECON|" }
    #    Then { writer.frames[700] == "FIRST |\nSECOND|" }
    #    Then { writer.frames[800] == "FIRST\nSECOND" }
    #  end
    #
    #  context "swiper and hider" do
    #    context "swiper" do
    #      Given(:strategy) { SwipeStrategy.new(message: "a", swiper: ">") }
    #      Then { writer.frames[0]   == "*" }
    #      Then { writer.frames[100] == ">" }
    #      Then { writer.frames[200] == "a>" }
    #      Then { writer.frames[300] == "a" }
    #    end
    #
    #    context "hider" do
    #      Given(:strategy) { SwipeStrategy.new(message: "a", hider: "#") }
    #      Then { writer.frames[0]   == "#" }
    #      Then { writer.frames[100] == "|" }
    #      Then { writer.frames[200] == "a|" }
    #      Then { writer.frames[300] == "a" }
    #    end
    #  end
    #end
  end
end
