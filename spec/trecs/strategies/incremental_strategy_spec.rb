require "spec_helper"
require "strategies/incremental_strategy"

module TRecs
  describe IncrementalStrategy do
    context "initialization" do
      When(:strategy1) { IncrementalStrategy.new(message: "HELLO") }
      Then { strategy1.message == "HELLO" }

      When(:strategy2) { IncrementalStrategy.new }
      Then { expect(strategy2).to have_failed(KeyError, /message/) }
    end

    context "recorder" do
      Given(:strategy) { IncrementalStrategy.new(message: "HELLO") }
      Given(:recorder) { Object.new }
      When { strategy.recorder = recorder }
      Then { strategy.recorder == recorder }
    end

    context "perform" do
      Given(:writer)   { InMemoryWriter.new }
      Given(:strategy) { IncrementalStrategy.new(message: "Hello World") }
      Given(:recorder) { Recorder.new(strategy: strategy, writer: writer) }

      When { strategy.recorder = recorder }
      When { recorder.record }
      When { strategy.perform }

      Then { writer.frames[0]    == ""            }
      Then { writer.frames[100]  == "H"           }
      Then { writer.frames[200]  == "He"          }
      Then { writer.frames[300]  == "Hel"         }
      Then { writer.frames[400]  == "Hell"        }
      Then { writer.frames[500]  == "Hello"       }
      Then { writer.frames[600]  == "Hello "      }
      Then { writer.frames[700]  == "Hello W"     }
      Then { writer.frames[800]  == "Hello Wo"    }
      Then { writer.frames[900]  == "Hello Wor"   }
      Then { writer.frames[1000] == "Hello Worl"  }
      Then { writer.frames[1100] == "Hello World" }
    end
  end
end
