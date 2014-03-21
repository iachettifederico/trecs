require "spec_helper"

require "player"
require "terminal_screen"

module TRecs
  describe Player do
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
