require "spec_helper"
require "recorder"
require "strategies/hash_strategy"
require "strategies/custom_strategy"

module TRecs
  describe Recorder do
    context "initialization" do
      Given(:writer)   { OpenStruct.new }
      Given(:strategy) { OpenStruct.new }

      When(:recorder) {
        Recorder.new(
          writer: writer,
          strategy: strategy,
          )
      }

      Then { recorder.writer == writer }
      Then { writer.recorder == recorder}

      Then { recorder.strategy == strategy }
      Then { strategy.recorder == recorder}

      Then { recorder.step == 100}
    end

    context "Recording" do
      Given { Spy.clear }
      Given(:writer)   { Spy.new("writer").ignore(:recorder=) }
      Given(:strategy) { Spy.new("strategy").ignore(:recorder=) }
      Given(:recorder) {
        Recorder.new(writer: writer, strategy: strategy)
      }

      When { recorder.record }

      Then { Spy.calls[1] == ["strategy", :write_frames_to, [writer]] }
    end

    context "#recording" do
      Given(:writer)   { InMemoryWriter.new }
      Given(:recorder) {
        Recorder.new(writer: writer, strategy: strategy)
      }
      Given(:strategy) { CustomStrategy.new }

      context "before start" do
        Then { recorder.recording == false }
      end

      context "when recording" do
        When(:recording) {
          result = nil
          strategy.action=( -> { result = recorder.recording })
          recorder.record
          result
        }
        Then { recording == true }
      end

      context "after finished start" do
        When { recorder.record }
        Then { recorder.recording == false }
      end
    end

    context "#next_timestamp" do
      Given(:writer)   { OpenStruct.new }
      Given(:strategy) { OpenStruct.new }

      Given(:recorder) {
        Recorder.new(
          writer:   writer,
          strategy: strategy,
          step:     50
          )
      }

      context "no stepping" do
        Then { recorder.current_time == nil }
      end

      context "one step" do
        When { recorder.next_timestamp == 0 }
        Then { recorder.current_time   == 0 }
      end

      context "two step" do
        When {
          recorder.next_timestamp
          recorder.next_timestamp  == 50
        }
        Then { recorder.current_time   == 50 }
      end
    end

    context "#stop" do
      Given { Spy.clear }
      Given(:writer)   { OpenStruct.new }
      Given(:strategy) { Spy.new("strategy").ignore(:recorder=) }

      Given(:recorder) {
        Recorder.new(
          writer:   writer,
          strategy: strategy,
          )
      }

      When { recorder.stop }

      Then { strategy.calls[1] == [:stop, []] }
    end
  end
end
