require "delegate"

module TRecs
  class TerminalScreen < SimpleDelegator
    def clear
      puts "\e[H\e[2J"
    end

    def initialize
      @obj = $stdout
      super(@obj)
    end

    def __getobj__
      @obj
    end

    def __setobj__(obj)
      @obj = obj
    end
  end
end
