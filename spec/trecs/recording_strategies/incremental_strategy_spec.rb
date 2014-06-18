require "spec_helper"
require "recording_strategies/incremental_strategy"

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
      Given { Spy.clear }
      Given(:recorder) { Spy.new("recorder") }
      Given(:strategy) { IncrementalStrategy.new(message: "Hello World") }

      When { recorder.stub(:step) { 100 } }
      When { strategy.recorder = recorder }
      When { strategy.perform }

      Then { recorder.calls[1]  == [:current_frame, [ {time: 0,    content: ""}           ] ] }
      Then { recorder.calls[2]  == [:current_frame, [ {time: 100,  content: "H"}           ] ] }
      Then { recorder.calls[3]  == [:current_frame, [ {time: 200,  content: "He"}          ] ] }
      Then { recorder.calls[4]  == [:current_frame, [ {time: 300,  content: "Hel"}         ] ] }
      Then { recorder.calls[5]  == [:current_frame, [ {time: 400,  content: "Hell"}        ] ] }
      Then { recorder.calls[6]  == [:current_frame, [ {time: 500,  content: "Hello"}       ] ] }
      Then { recorder.calls[7]  == [:current_frame, [ {time: 600,  content: "Hello "}      ] ] }
      Then { recorder.calls[8]  == [:current_frame, [ {time: 700,  content: "Hello W"}     ] ] }
      Then { recorder.calls[9]  == [:current_frame, [ {time: 800,  content: "Hello Wo"}    ] ] }
      Then { recorder.calls[10] == [:current_frame, [ {time: 900,  content: "Hello Wor"}   ] ] }
      Then { recorder.calls[11] == [:current_frame, [ {time: 1000, content: "Hello Worl"}  ] ] }
      Then { recorder.calls[12] == [:current_frame, [ {time: 1100, content: "Hello World"} ] ] }
    end
  end
end
