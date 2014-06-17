module TRecs
  class TerminalInputTicker
    attr_accessor :player

    def start
      while (input = gets) =~ /\A[0-9]+\Z/
        time = input.to_i
        player.tick(time)
      end
    end
  end
end
