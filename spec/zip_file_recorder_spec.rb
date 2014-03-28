require "spec_helper"
require "zip"

require "zip_file_recorder"
require "zip_file_player"

module TRecs
  describe ZipFileRecorder do
    class DummyZipFileRecorder < ZipFileRecorder
      def perform_recording
        current_frame(time: 0, content: "zero")
        current_frame(time: 1, content: "one")
        current_frame(time: 2, content: "two")
      end
    end

    it "expects a file name" do
      expect { ZipFileRecorder.new }.to raise_error
    end

    it "generates a .trecs compressed file" do
      file_name = "tmp/i_should_exist.trecs"
      recorder  = ZipFileRecorder.new(file_name: file_name)

      recorder.record

      File.exists?(file_name).should be_true
      expect { Zip::File.open(file_name) }.not_to raise_error(Zip::ZipError)
    end

    it "has the correct frames" do
      file_name = "tmp/zero_one_two.trecs"
      recorder  = DummyZipFileRecorder.new(file_name: file_name)

      recorder.record

      player = ZipFilePlayer.new(file_name: file_name)

      player.timestamps.should == [0, 1, 2]
      player.get_frame(0).should == "zero"
      player.get_frame(1).should == "one"
      player.get_frame(2).should == "two"
    end

  end
end
