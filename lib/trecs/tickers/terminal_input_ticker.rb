module TRecs
  class TerminalInputTicker
    attr_accessor :player
    def initialize(*)
    end
    
    def start
      while (input = gets) =~ /\A[0-9]+\Z/
        time = input.to_i
        player.tick(time)
      end
    end
    def to_s
      "<#{self.class}>"
    end
    alias :inspect :to_s
  end
end
