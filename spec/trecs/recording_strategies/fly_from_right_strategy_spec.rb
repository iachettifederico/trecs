require "spec_helper"
require "recording_strategies/fly_from_right_strategy"

module TRecs
  describe FlyFromRightStrategy do
    context "initialization" do
      When(:strategy1) { FlyFromRightStrategy.new(message: "HELLO") }
      Then { strategy1.message == "HELLO" }

      When(:strategy2) { FlyFromRightStrategy.new }
      Then { expect(strategy2).to have_failed(KeyError, /message/) }
    end

    context "with/message relation" do
      context "same size" do
        When(:strategy) { FlyFromRightStrategy.new(message: "HELLO", width: 5) }
        Then { strategy.width == 5 }
      end

      context "with greater than message" do
        When(:strategy) { FlyFromRightStrategy.new(message: "HELLO", width: 10) }
        Then { strategy.width == 10 }
      end

      context "with not big enough" do
        When(:strategy) { FlyFromRightStrategy.new(message: "HELLO", width: 2) }
        Then { strategy.width == 5 }
      end
    end

    context "recorder" do
      Given(:strategy) { FlyFromRightStrategy.new(message: "HELLO") }
      Given(:recorder) { Object.new }
      When { strategy.recorder = recorder }
      Then { strategy.recorder == recorder }
    end

    context "perform" do
      Given { Spy.clear }
      Given(:recorder) { Spy.new("recorder") }
      Given(:strategy) { FlyFromRightStrategy.new(message: "abc", width: 4) }

      When { recorder.stub(:step) { 100 } }
      When { strategy.recorder = recorder }
      When { strategy.perform }

      Then { recorder.calls[1]  == [:current_frame, [ {time: 0,    content: ""                  } ] ] }
      Then { recorder.calls[2]  == [:current_frame, [ {time: 100,  content: "   a" } ] ] }
      Then { recorder.calls[3]  == [:current_frame, [ {time: 200,  content: "  a"  } ] ] }
      Then { recorder.calls[4]  == [:current_frame, [ {time: 300,  content: " a"   } ] ] }
      Then { recorder.calls[5]  == [:current_frame, [ {time: 400,  content: "a"    } ] ] }

      Then { recorder.calls[6]  == [:current_frame, [ {time: 500,  content: "a"    } ] ] }
      Then { recorder.calls[7]  == [:current_frame, [ {time: 600,  content: "a  b" } ] ] }
      Then { recorder.calls[8]  == [:current_frame, [ {time: 700,  content: "a b"  } ] ] }
      Then { recorder.calls[9]  == [:current_frame, [ {time: 800,  content: "ab"   } ] ] }

      Then { recorder.calls[10] == [:current_frame, [ {time: 900,  content: "ab"    } ] ] }
      Then { recorder.calls[11] == [:current_frame, [ {time: 1000, content: "ab c" } ] ] }
      Then { recorder.calls[12] == [:current_frame, [ {time: 1100, content: "abc"  } ] ] }

    end

    context "shell command" do
      Then { skip("Test shell command") }
    end
  end
end