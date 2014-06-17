require "spec_helper"

require "player"

module TRecs
  describe Player do
    context "initialization" do
      Given(:reader) { OpenStruct.new }
      Given(:ticker) { OpenStruct.new }
      Given(:screen) { Object.new }

      When(:player) {
        Player.new(
          reader: reader,
          ticker: ticker,
          screen: screen,
          )
      }

      Then { player.reader == reader }
      Then { reader.player == player}

      Then { player.ticker == ticker }
      Then { ticker.player == player}

      Then { player.step == 100}
      Then { player.screen == screen}
    end

    context "Playing" do
      Given { Spy.clear }
      Given(:reader)   { Spy.new("reader").ignore(:player=) }
      Given(:ticker)   { Spy.new("ticker").ignore(:player=) }
      Given(:player) {
        Player.new(reader: reader, ticker: ticker)
      }

      When { player.play }

      Then { Spy.calls[1] == ["reader", :setup,   []] }
      Then { Spy.calls[2] == ["ticker", :start, []] }
    end

    context "Playing some frames" do
      Given { Spy.clear }
      Given(:screen)   { Spy.new("screen") }
      Given(:player) {
        Player.new(reader: reader, ticker: ticker, screen: screen)
      }

      When { player.play }

      context "no repetitions" do
        Given(:reader)   { CustomReader.new(0 => "a", 100 => "b") }
        Given(:ticker)   { CustomTicker.new(0, 100) }

        Then { screen.calls[1] == [:clear, []] }
        Then { screen.calls[2] == [:puts,  ["a"]] }
        Then { screen.calls[3] == [:clear, []] }
        Then { screen.calls[4] == [:puts,  ["b"]] }
        Then { screen.calls.size == 4 }
      end

      context "with repetitions" do
        Given(:reader)   { CustomReader.new(0 => "a", 100 => "b", 200 => "b") }
        Given(:ticker)   { CustomTicker.new(0, 100, 200) }

        Then { screen.calls[1] == [:clear, []] }
        Then { screen.calls[2] == [:puts,  ["a"]] }
        Then { screen.calls[3] == [:clear, []] }
        Then { screen.calls[4] == [:puts,  ["b"]] }
        Then { screen.calls.size == 4 }
      end
    end

    context "content at time" do
      Given(:screen) { OpenStruct.new }
      Given(:ticker) { OpenStruct.new }
      Given(:reader) { CustomReader.new(0 => "a", 100 => "b", 200 => "c") }

      Given(:player) {
        Player.new(reader: reader, ticker: ticker, screen: screen)
      }

      #When { player.play }

      Then { player.timestamps == [0, 100, 200] }
      Then { player.time_to_play(nil)   == 0 }
      Then { player.time_to_play(0)   == 0 }
      Then { player.time_to_play(100) == 100 }
      Then { player.time_to_play(50)  == 0 }
      Then { player.time_to_play(101) == 100 }
      Then { player.time_to_play(199) == 100 }
      Then { player.time_to_play(1000) == 200 }
    end
  end
end
