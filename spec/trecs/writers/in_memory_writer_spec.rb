require "spec_helper"
require "writers/in_memory_writer"

module TRecs
  describe InMemoryWriter do
    context "recorder" do
      Given(:writer) {
        InMemoryWriter.new
      }
      Given(:recorder) { Object.new }
      When { writer.recorder = recorder }
      Then { writer.recorder == recorder }
    end

    context "recording frames" do
      Given(:writer) {
        InMemoryWriter.new
      }
      Given(:recorder) { Object.new }

      context "after setup" do
        When { writer.setup }
        Then { writer.frames == {} }
      end

      context "after recording frames" do
        When { writer.setup }
        When { writer.create_frame(time: 0,   content: "A") }
        When { writer.create_frame(time: 100, content: "B") }
        When { writer.create_frame(time: 200, content: "C") }

        Then {
          writer.frames == {
            0   => "A",
            100 => "B",
            200 => "C",
          } }
      end
    end

    context "render_frames" do
      Given(:strategy) { InMemoryWriter.new }
      Given(:frames) { { 0 => "A", 100 => "B" } }
      When(:result) { strategy.render_frames(frames) }
      Then { result == frames }
    end
  end
end
