require "spec_helper"
require "strategies/strategy"

module TRecs
  class MyStrategy < Strategy
    attr_accessor :action

    def perform
      current_time(0)
      current_content("A")
      current_format("raw")
      save_frame

      current_time(10)
      current_content("<p>B</p>")
      current_format("html")
      save_frame

      current_time(50)
      current_content("C")
      save_frame
    end
  end

  describe Strategy do
    Given(:strategy) { MyStrategy.new }

    context "recorder" do
      When { strategy.recorder = :recorder }
      Then { strategy.recorder == :recorder }
    end

    context "performing" do
      Given(:writer)   { InMemoryWriter.new }
      When { strategy.write_frames_to(writer) }

      Then { writer.frames[0].content == "A" }
      Then { writer.frames[0].format  == "raw" }

      Then { writer.frames[10].content == "<p>B</p>" }
      Then { writer.frames[10].format  == "html" }
    end

  end
end
