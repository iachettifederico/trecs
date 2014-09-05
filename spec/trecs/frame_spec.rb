require "spec_helper"
require "frame"

module TRecs
  describe Frame do
    context "content" do
      context "initializer" do
        Given(:frame) { Frame.new(content: "THE CONTENT") }
        Then { frame.content == "THE CONTENT" }
        Then { frame.format  == "raw" }
      end
      context "set aftewards" do
        Given(:frame) { Frame.new }
        When { frame.content = "THE NEW CONTENT" }
        Then { frame.content == "THE NEW CONTENT" }
      end
    end

    context "width" do
      context "one line" do
        Given(:frame) { Frame.new("123456") }
        Then { frame.width == 6 }
      end
      context "multiple lines" do
        Given(:frame) { Frame.new(<<FRAME
123
12345
12
FRAME
            ) }
        Then { frame.width == 5 }
      end
    end

    context "equality" do
      Then { Frame.new(content: "A") == Frame.new("A") }
      Then { Frame.new(content: "B") == "B" }
      Then { Frame.new(content: "C", format: "raw") != Frame.new(content: "C", format: "html") }
    end

    context "height" do
      context "one line" do
        Given(:frame) { Frame.new("LINE 1") }
        Then { frame.height == 1 }
      end
      context "multiple lines" do
        Given(:frame) { Frame.new(<<FRAME
LINE 1
LINE 2
LINE 3
FRAME
            ) }
        Then { frame.height == 3 }
      end
    end

    context "each" do
      Given(:content) { "a\nb\nc\n" }
      Given(:frame) { Frame.new(content) }
      Then {
        frame.each
          .zip(content.each_line)
          .all?{ |actual, expected|
          actual == expected
        }
      }
      Then { frame.is_a? Enumerable }
    end

    context "#to_s" do
      Given(:frame) { Frame.new("FRAME CONTENT") }
      Then { frame.to_s == "FRAME CONTENT" }
    end
  end
end
