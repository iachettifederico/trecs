require "spec_helper"
require "tickers/clock_ticker"

module TRecs
  class DummyDelayer
    def sleep(*)
    end
    def self.sleep(*)
    end
  end
end

module TRecs
  describe ClockTicker do
    context "player" do
      Given(:ticker) {
        ClockTicker.new
      }
      Given(:player) { Object.new }
      When { ticker.player = player }
      Then { ticker.player == player }
    end

    context "#delayer" do
      context "constructor" do
        Given(:delayer) { Object.new }
        Given(:ticker)  { ClockTicker.new(delayer: delayer) }
        Then { ticker.delayer == delayer }
      end

      context "default" do
        Given(:ticker) { ClockTicker.new }
        Then { ticker.delayer == Kernel }
      end
    end

    context "timestamps" do
      context "from player by default" do

        Given(:timestamps) { [1, 2, 3] }
        Given(:player)  { OpenStruct.new(timestamps: timestamps)  }

        Given(:ticker) { ClockTicker.new }

        When { ticker.player = player }

        Then { ticker.timestamps == timestamps }
      end

      context "force" do
        Given(:timestamps) { [10, 20, 30] }
        Given(:player)  { Object.new }

        Given(:ticker) { ClockTicker.new(timestamps: timestamps) }

        When { ticker.player = player }

        Then { ticker.timestamps == timestamps }
      end
    end

    context "ticking" do
      Given(:delayer) { Spy.new(:delayer) }
      Given(:player)  { Spy.new(:player) }
      Given(:ticker)  { ClockTicker.new(delayer: delayer, timestamps: [0, 10, 30, 60, 160]) }

      When { ticker.player = player }
      When { ticker.start }

      context "player" do
        Then { player.calls[1] == [:tick, [0]]  }
        Then { player.calls[2] == [:tick, [10]] }
        Then { player.calls[3] == [:tick, [30]] }
        Then { player.calls[4] == [:tick, [60]] }
        Then { player.calls[5] == [:tick, [160]] }
      end

      context "delayer" do
        Then { delayer.calls[1] == [:sleep, [0]] }
        Then { delayer.calls[2] == [:sleep, [0.01]] }
        Then { delayer.calls[3] == [:sleep, [0.02]] }
        Then { delayer.calls[4] == [:sleep, [0.03]] }
        Then { delayer.calls[5] == [:sleep, [0.1]] }
      end
    end

    context "#from and #to" do
      Given(:player)  { Object.new }

      When { ticker.player = player }

      context "#from" do
        context "exact" do
          Given(:ticker)  { ClockTicker.new(from: 20, timestamps: [0, 10, 20, 30, 40]) }
          Then { ticker.timestamps == [20, 30, 40]  }
        end

        context "not exact" do
          Given(:ticker)  { ClockTicker.new(from: 19, timestamps: [0, 10, 20, 30, 40]) }
          Then { ticker.timestamps == [19, 20, 30, 40]  }
        end

      end

      context "#to" do
        context "exact" do
          Given(:ticker)  { ClockTicker.new(to: 20, timestamps: [0, 10, 20, 30, 40]) }
          Then { ticker.timestamps == [0, 10, 20]  }
        end

        context "zero" do
          Given(:ticker)  { ClockTicker.new(to: 0, timestamps: [0, 10, 20, 30, 40]) }
          Then { ticker.timestamps == [0, 10, 20, 30, 40]  }
        end

        context "not exact" do
          Given(:ticker)  { ClockTicker.new(to: 23, timestamps: [0, 10, 20, 30, 40]) }
          Then { ticker.timestamps == [0, 10, 20, 23]  }
        end
      end

      context "full example" do
        Given(:delayer) { Spy.new(:delayer) }
        Given(:delayer) { Spy.new(:delayer) }
        Given(:player)  { Spy.new(:player) }
        Given(:ticker)  {
          ClockTicker.new(
            from:       3,
            to:         28,
            timestamps: [0, 10, 20, 30, 40],
            delayer:    delayer)
        }

        When { ticker.start }

        Then { ticker.timestamps == [3, 10, 20, 28]  }

        context "player" do
          Then { player.calls[1] == [:tick, [3]]  }
          Then { player.calls[2] == [:tick, [10]] }
          Then { player.calls[3] == [:tick, [20]] }
          Then { player.calls[4] == [:tick, [28]] }
        end

        context "delayer" do
          Then { delayer.calls[1] == [:sleep, [0]] }
          Then { delayer.calls[2] == [:sleep, [0.007]] }
          Then { delayer.calls[3] == [:sleep, [0.01]] }
          Then { delayer.calls[4] == [:sleep, [0.008]] }
        end
      end
    end

    context "#speed" do
      Given { Spy.clear }

      Given(:player)  { Spy.new(:player) }
      Given(:delayer) { Spy.new(:delayer) }

      When { ticker.player = player }
      When { ticker.start }

      context "2x" do
        Given(:ticker)  {
          ClockTicker.new(
            speed: 2,
            delayer: delayer,
            timestamps: [0, 100, 300]
            )
        }
        Then { player.calls[1]  == [:tick,  [0]] }
        Then { delayer.calls[1] == [:sleep, [0]] }

        Then { player.calls[2]  == [:tick,  [100]] }
        Then { delayer.calls[2] == [:sleep, [0.05]] }

        Then { player.calls[3]  == [:tick,  [300]] }
        Then { delayer.calls[3] == [:sleep, [0.1]] }
      end

      context "1.5x" do
        Given(:ticker)  {
          ClockTicker.new(
            speed: 1.5,
            delayer: delayer,
            timestamps: [0, 100, 300]
            )
        }
        Then { player.calls[1]  == [:tick,  [0]] }
        Then { delayer.calls[1] == [:sleep, [0]] }

        Then { player.calls[2]  == [:tick,  [100]] }
        Then { delayer.calls[2] == [:sleep, [0.06666666666666667]] }

        Then { player.calls[3]  == [:tick,  [300]] }
        Then { delayer.calls[3] == [:sleep, [0.13333333333333333]] }
      end

      context "negative" do
        skip("Test negtive speeds")
      end
    end
  end
end
