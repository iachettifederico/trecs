require "spec_helper"
require "recorder"
require "recording_strategies/hash_strategy"
require "recording_strategies/custom_strategy"

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

      Then { Spy.calls[1] == ["writer",   :setup,   []] }
      Then { Spy.calls[2] == ["strategy", :perform, []] }
      Then { Spy.calls[3] == ["writer",   :render,  []] }
    end

    context "#recording" do
      Given(:writer)   { OpenStruct.new }
      Given(:strategy) { OpenStruct.new }
      Given(:recorder) {
        Recorder.new(writer: writer, strategy: strategy)
      }

      context "before start" do
        Then { recorder.recording == false }
      end

      context "when recording" do
        Given(:strategy) { CustomStrategy.new }

        When(:recording) {
          result = nil
          strategy.action = -> { result = recorder.recording }
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

    context "#current_frame" do
      Given   { Spy.clear }
      Given(:writer)   { Spy.new("Writer").ignore(:recorder=, :setup, :render) }
      Given(:strategy) { CustomStrategy.new }

      Given(:recorder) {
        Recorder.new(writer: writer, strategy: strategy)
      }

      context "setting current frame and time" do
        When(:result) {
          result = []
          strategy.action = -> {
            recorder.current_frame(time: 10, content: "CONTENT")
            result << {
              time: recorder.current_time,
              content: recorder.current_content,
            }
            recorder.current_frame(time: 15, content: "CONTENT 2")
            result << {
              time: recorder.current_time,
              content: recorder.current_content,
            }
          }
          recorder.record
          result
        }

        Then {
          result == [
            {time: 10, content: "CONTENT"},
            {time: 15, content: "CONTENT 2"},
          ]
        }
        Then {
          writer.calls[1] == [
            :create_frame,
            [ { time: 10, content: "CONTENT" } ]
          ]
        }
        Then {
          writer.calls[2] == [
            :create_frame,
            [ { time: 15, content: "CONTENT 2" } ]
          ]
        }
      end
    end

    context "#current_frame" do
      Given   { Spy.clear }
      Given(:writer)   { Spy.new("Writer").ignore(:recorder=, :setup, :render) }
      Given(:strategy) { CustomStrategy.new }

      Given(:recorder) {
        Recorder.new(writer: writer, strategy: strategy)
      }

      context "setting current frame and time with content duplicates" do
        When {
          strategy.action = -> {
            recorder.current_frame(time: 10, content: "CONTENT")
            recorder.current_frame(time: 15, content: "CONTENT 2")
            recorder.current_frame(time: 20, content: "CONTENT 2")
            recorder.current_frame(time: 25, content: "CONTENT 3")
          }
          recorder.record
        }

        Then {
          writer.calls[1] == [
            :create_frame,
            [ { time: 10, content: "CONTENT" } ]
          ]
        }
        Then {
          writer.calls[2] == [
            :create_frame,
            [ { time: 15, content: "CONTENT 2" } ]
          ]
        }
        Then {
          writer.calls[3] == [
            :create_frame,
            [ { time: 25, content: "CONTENT 3" } ]
          ]
        }
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

    context "Offset" do
      Given   { Spy.clear }
      Given(:writer)   { Spy.new("Writer").ignore(:recorder=, :setup, :render) }
      Given(:strategy) { CustomStrategy.new }

      Given(:recorder) {
        Recorder.new(offset: 7, writer: writer, strategy: strategy, step: 10)
      }

      context "setting current frame and time with content duplicates" do
        When {
          strategy.action = -> {
            recorder.current_frame(time: 0,  content: "CONTENT")
            recorder.current_frame(time: 10, content: "CONTENT 2")
            recorder.current_frame(time: 12, content: "CONTENT 3")
            recorder.current_frame(          content: "CONTENT 4")
          }
          recorder.record
        }

        Then {
          writer.calls[1] == [
            :create_frame,
            [ { time: 7, content: "CONTENT" } ]
          ]
        }
        Then {
          writer.calls[2] == [
            :create_frame,
            [ { time: 17, content: "CONTENT 2" } ]
          ]
        }
        Then {
          writer.calls[3] == [
            :create_frame,
            [ { time: 19, content: "CONTENT 3" } ]
          ]
        }
        Then { recorder.current_time == 22 }
        Then {
          writer.calls[4] == [
            :create_frame,
            [ { time: 29, content: "CONTENT 4" } ]
          ]
        }
      end

    end
  end
end
