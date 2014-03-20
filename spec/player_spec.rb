require "spec_helper"

require "player"

module TRecs
  describe Player do
    context "output" do
      it "receives a Screen object to manage output" do
        player = Player.new(output: :output)

        player.output.should == :output
      end

      it "defaults to the standard output" do
        player = Player.new

        player.output.should == $stdout
      end

    end
  end

end
