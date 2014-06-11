require "spec_helper"

require "recorders/message_recorder"

module TRecs
  describe Recorder do
    class DummyRecorder < Recorder
      attr_reader :result

      def initialize(options={})
        frames = options.fetch(:frames) { nil }
        @frames = frames.is_a?(Hash) ? frames : Array(frames)
        super(options)
      end

      def perform_recording
        if @frames.is_a?(Hash)
          @frames.each do |time, content|
            current_frame(time: time, content: content)
          end
        else
          @frames.each do |content|
            current_frame(content: content)
          end
        end
      end

      def create_frame
        @result[current_time] = current_content
      end

      def setup
        @result = {}
      end

      def render
        # no-op
      end
    end

    context "recording" do
      context "with custom timestamps" do
        it "records a one frame trecs" do
          rec = DummyRecorder.new frames: {0 => "a"}
          rec.record

          rec.result.should == {0 => "a"}
        end

        it "records a two frames trecs" do
          rec = DummyRecorder.new frames: {
            0 => "a",
            100 => "b"
          }
          rec.record

          rec.result.should == {
            0 => "a",
            100 => "b"
          }
        end

        it "records a three frames trecs" do
          rec = DummyRecorder.new frames: {
            0   => "a",
            100 => "b",
            150 => "c"
          }
          rec.record

          rec.result.should == {
            0   => "a",
            100 => "b",
            150 => "c"
          }
        end

        it "calls start_recording" do
          rec = DummyRecorder.new
          rec.should_receive(:setup)

          rec.record
        end

        it "calls finish_recording" do
          rec = DummyRecorder.new
          rec.should_receive(:render)

          rec.record
        end

      end

      context "with custom timestamps" do
        it "records a one frame trecs" do
          rec = DummyRecorder.new frames: ["a"]
          rec.record

          rec.result.should == {0 => "a"}
        end

        it "records a two frames trecs" do
          rec = DummyRecorder.new frames: ["a", "b"]
          rec.record

          rec.result.should == {
            0   => "a",
            100 => "b"
          }
        end

        it "records a three frames trecs" do
          rec = DummyRecorder.new frames: ["a", "b", "c"]
          rec.record

          rec.result.should == {
            0   => "a",
            100 => "b",
            200 => "c"
          }
        end

        it "records a three frames trecs" do
          rec = DummyRecorder.new frames: ["a", "b", "c"], step: 75
          rec.record

          rec.result.should == {
            0   => "a",
            75  => "b",
            150 => "c"
          }
        end
      end

      context "sanitizing the recording" do
        it "records a three frames trecs" do
          rec = DummyRecorder.new frames: {
            0   => "a",
            50  => "b",
            100 => "b",
            150 => "c",
          }
          rec.record

          rec.result.should == {
            0   => "a",
            50  => "b",
            150 => "c",
          }
        end

        it "records a three frames trecs" do
          rec = DummyRecorder.new frames: {
            0   => "a",
            50  => "a",
            100 => "b",
            150 => "c",
          }
          rec.record

          rec.result.should == {
            0   => "a",
            100 => "b",
            150 => "c",
          }
        end

        it "records a three frames trecs" do
          rec = DummyRecorder.new frames: {
            0   => "a",
            50  => "b",
            100 => "c",
            150 => "c",
          }
          rec.record

          rec.result.should == {
            0   => "a",
            50  => "b",
            100 => "c",
          }
        end

      end
    end


    context "timestamps" do
      it "starts with 0 as the current time" do
        rec = Recorder.new

        rec.current_time.should == nil
      end

      it "calculates the next timestamp" do
        rec = Recorder.new(step: 100)

        rec.next_timestamp.should == 0
        rec.current_time.should   == 0
      end

      it "calculates the second next timestamp" do
        rec = Recorder.new(step: 100)

        rec.next_timestamp
        rec.next_timestamp.should == 100
        rec.current_time.should   == 100
      end
    end

    describe "#current_time" do
      it "sets the current time" do
        rec = Recorder.new

        rec.current_time(40)

        rec.current_time.should == 40
      end
    end

    describe "#current_content" do
      it "sets the current time" do
        rec = Recorder.new

        rec.current_content("HELLO")

        rec.current_content.should == "HELLO"
      end
    end

    describe "#current_frame" do
      it "sets the current time and content" do
        rec = Recorder.new

        rec.current_frame(time: 40, content: "HELLO")

        rec.current_time.should    == 40
        rec.current_content.should == "HELLO"
      end

      it "sets the current time and content" do
        rec = Recorder.new()
        rec.should_receive(:create_frame)

        rec.current_frame(time: 40, content: "HELLO")
      end
    end
  end
end
