require "strategies/strategy"
module TRecs
  class CustomStrategy < Strategy

    attr_accessor :recorder
    attr_accessor :action

    def initialize(action = ->{})
      @action = action
    end
    
    def perform
      self.action.call
    end
  end
end
