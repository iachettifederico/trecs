require "spec_helper"
require "strategies/hash_strategy"

module TRecs
  describe HashStrategy do
    context "initialization" do
      When(:strategy1) { HashStrategy.new({}) }
      Then { strategy1.frames == {} }

      When(:strategy2) { HashStrategy.new }
      Then { strategy2.frames == {} }
    end

    context "recorder" do
      Given(:strategy) { HashStrategy.new }
      Given(:recorder) { Object.new }
      When { strategy.recorder = recorder }
      Then { strategy.recorder == recorder }
    end

    context "perform" do
      Given { Spy.clear }
      Given(:recorder) { Spy.new("recorder") }
      Given(:strategy) { HashStrategy.new(
          {
            0         => "A",
            10.0      => "B",
            "15"      => "C",
            "1a2b3C4" => "h",
            20        => "D",
            :"25"        => "E",
          }
          ) }

      When { strategy.recorder = recorder }
      When { strategy.perform }

      Then { recorder.calls[1]  == [:current_frame, [ {time: 0,  content: "A"} ] ] }
      Then { recorder.calls[2]  == [:current_frame, [ {time: 10, content: "B"} ] ] }
      Then { recorder.calls[3]  == [:current_frame, [ {time: 15, content: "C"} ] ] }
      Then { recorder.calls[4]  == [:current_frame, [ {time: 20, content: "D"} ] ] }
      Then { recorder.calls[5]  == [:current_frame, [ {time: 25, content: "E"} ] ] }
    end
  end
end