require "spec_helper"
require "zip"

require "recorders/zip_file_recorder"
require "players/zip_file_player"

module TRecs
  describe ZipFileRecorder do
    class DummyRecordingStrategy
      attr_reader :recorder

      def initialize(options={})
        @recorder = options.fetch(:recorder)
      end
      def perform
        recorder.current_frame(time: 0, content: "zero")
        recorder.current_frame(time: 1, content: "one")
        recorder.current_frame(time: 2, content: "two")
      end
    end

    class DummyZipFileRecorder < ZipFileRecorder
      def initialize(options)
        @recording_strategy = DummyRecordingStrategy.new(recorder: self)
        super
      end
    end

    it "expects a file name" do
      expect { ZipFileRecorder.new }.to raise_error
    end

    it "generates a .trecs compressed file" do
      file_name = "tmp/i_should_exist.trecs"
      recorder  = DummyZipFileRecorder.new(file_name: file_name)

      recorder.record

      File.exists?(file_name).should be_truthy
      expect { Zip::File.open(file_name) }.not_to raise_error
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
