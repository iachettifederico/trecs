require "spec_helper"
require "recording_strategies/asterisk_swipe_strategy"

require "recorder"
require "recording_strategies/hash_strategy"
require "writers/in_memory_writer"

module TRecs
  describe AsteriskSwipeStrategy do
    context "initialization" do
      When(:strategy) { AsteriskSwipeStrategy.new }
      Then { expect(strategy).to have_raised(/key not found: :text/) }
    end

    context "performing" do
      Given(:writer)   { InMemoryWriter.new }
      Given(:recorder) { Recorder.new(strategy: strategy, writer: writer) }

      When { strategy.recorder = recorder }
      When { recorder.record }

      context "one char" do
        Given(:strategy) { AsteriskSwipeStrategy.new(text: "a") }
        Then { writer.frames[0]   == "*" }
        Then { writer.frames[100] == "|" }
        Then { writer.frames[200] == "a|" }
        Then { writer.frames[300] == "a" }
      end

      context "two chars" do
        Given(:strategy) { AsteriskSwipeStrategy.new(text: "ab", step: 10) }
        Then { writer.frames[0]  == "**" }
        Then { writer.frames[10] == "|*" }
        Then { writer.frames[20] == "a|" }
        Then { writer.frames[30] == "ab|" }
        Then { writer.frames[40] == "ab" }
      end

      context "multiple_lines" do
        Given(:strategy) { AsteriskSwipeStrategy.new(text: "FIRST\nSECOND") }
        Then { writer.frames[0]   == "******\n******" }
        Then { writer.frames[100] == "|*****\n|*****" }
        Then { writer.frames[200] == "F|****\nS|****" }
        Then { writer.frames[300] == "FI|***\nSE|***" }
        Then { writer.frames[400] == "FIR|**\nSEC|**" }
        Then { writer.frames[500] == "FIRS|*\nSECO|*" }
        Then { writer.frames[600] == "FIRST|\nSECON|" }
        Then { writer.frames[700] == "FIRST |\nSECOND|" }
        Then { writer.frames[800] == "FIRST\nSECOND" }
      end
    end

  end
end
