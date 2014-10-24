require "spec_helper"
require "strategies/fly_from_right_strategy"

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
      Given(:writer)   { InMemoryWriter.new }
      Given(:strategy) { FlyFromRightStrategy.new(message: "abc", width: 4) }
      Given(:recorder) { Recorder.new(strategy: strategy, writer: writer) }

      When { strategy.recorder = recorder }
      When { recorder.record }

      When { recorder.stub(:step) { 100 } }
      When { strategy.recorder = recorder }

      Then { writer.frames[0]    ==  ""     }
      Then { writer.frames[100]  ==  "   a" }
      Then { writer.frames[200]  ==  "  a"  }
      Then { writer.frames[300]  ==  " a"   }
      Then { writer.frames[400]  ==  "a"    }

      Then { writer.frames[500]  ==  "a"    }
      Then { writer.frames[600]  ==  "a  b" }
      Then { writer.frames[700]  ==  "a b"  }
      Then { writer.frames[800]  ==  "ab"   }

      Then { writer.frames[900]  ==  "ab"   }
      Then { writer.frames[1000] ==  "ab c" }
      Then { writer.frames[1100] ==  "abc"  }

    end
  end
end
