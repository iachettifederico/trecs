require "spec_helper"

require "message_recorder"

module TRecs
  describe Recorder do
    context "timestamps" do
      it "starts with 0 as the current time" do
        rec = Recorder.new

        rec.current_time.should == 0
      end

      it "calculates the next timestamp" do
        rec = Recorder.new(step: 100)

        rec.next_timestamp.should == 100
        rec.current_time.should   == 100
      end

      it "calculates the second next timestamp" do
        rec = Recorder.new(step: 100)

        rec.next_timestamp
        rec.next_timestamp.should == 200
        rec.current_time.should   == 200
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
