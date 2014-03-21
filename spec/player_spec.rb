require "spec_helper"

require "player"
require "terminal_screen"

module TRecs
  class DummyPlayer < Player
    def initialize(frames:, **options)
      @frames = frames
      super
    end

    def get_timestamps
      @frames.keys
    end

    def get_frame(time)
      @frames[time]
    end
  end

  class DummyOutput
    def initialize
      @output = []
    end

    def puts(str=nil)
      @output << str.to_s
    end

    def clear_screen
      @output << :clear_screen
    end

    def raw_output
      @output
    end

    def output
      @output.select { |f| f.is_a? String }
    end
  end


  describe Player do
    define :have_frames do |expected|
      match do |actual|
        raw_expected = expected.map { |o| [:clear_screen, o]  }.flatten
        a = actual.raw_output == raw_expected
        b = actual.output     == expected
        a && b
      end
    end

    def create_recording
      frames = {}
      yield frames
      DummyPlayer.new(frames: frames, output: output)
    end

    let(:output) { DummyOutput.new }

    it "reads a one frame screencast" do
      player = create_recording do |frames|
        frames[0] = "FIRST FRAME"
      end

      player.play

      output.should have_frames ["FIRST FRAME"]
    end

    it "returns the frame at certain time" do
      player = create_recording do |frames|
        frames[0]   = "FIRST FRAME",
        frames[100] = "FRAME AT 100"
      end

      player.play_frame(100)

      output.should have_frames ["FRAME AT 100"]
    end

    it "returns the previous frame if no frame at certain time" do
      player = create_recording do |frames|
        frames[0]   = "FIRST FRAME"
        frames[100] = "FRAME AT 100"
        frames[200] = "FRAME AT 200"
      end

      player.play_frame(111)

      output.output.should == ["FRAME AT 100"]
    end

    it "returns the last frame if asking for exceeding time" do
      player = create_recording do |frames|
        frames[0]   = "FIRST FRAME"
        frames[100] = "FRAME AT 100"
        frames[200] = "FRAME AT 200"
      end

      player.play_frame(201)

      output.should have_frames ["FRAME AT 200"]

    end

    describe "multiple frame screencast" do
      it "playing two frames" do
        player = create_recording do |frames|
          frames[0]   = "FIRST FRAME"
          frames[100] = "FRAME AT 100"
        end

        player.play

        output.should have_frames [
          "FIRST FRAME",
          "FRAME AT 100"
        ]
      end

      it "playing all the frames" do
        player = create_recording do |frames|
          frames[0]   = "FIRST FRAME"
          frames[100] = "FRAME AT 100"
          frames[200] = "FRAME AT 200"
        end

        player.play

        output.should have_frames [
          "FIRST FRAME",
          "FRAME AT 100",
          "FRAME AT 200"
        ]
      end

      it "playing a recording" do
        player = create_recording do |frames|
          frames[0]   = "FIRST FRAME"
          frames[100] = "FRAME AT 100"
          frames[200] = "FRAME AT 200"
          frames[301] = "FRAME AT 301"
          frames[499] = "FRAME AT 499"
          frames[599] = "FRAME AT 599"
        end

        player.play

        output.should have_frames [
          "FIRST FRAME",
          "FRAME AT 100",
          "FRAME AT 200",
          "FRAME AT 200",
          "FRAME AT 301",
          "FRAME AT 499",
          "FRAME AT 599",
        ]
      end
    end

    context "Timestamps" do
      it "returns all the frame timestamps" do
        player = create_recording do |frames|
          frames[0]   = "FIRST FRAME"
          frames[100] = "FRAME AT 100"
          frames[200] = "FRAME AT 200"
        end

        player.timestamps.should == [0, 100, 200]

      end

    end

    context "output" do
      it "receives a Screen object to manage output" do
        player = Player.new(output: :output)

        player.output.should == :output
      end

      it "defaults to the Terminal Screen" do
        player = Player.new

        player.output.class.should == TerminalScreen
      end

      context "message ... puts ... print" do
      end
    end
  end

end
