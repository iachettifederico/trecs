require "recording_strategies/fly_from_right_strategy"

module TRecs
  class ShellCommandStrategy < FlyFromRightStrategy
    attr_reader :command

    def initialize(options={})
      super
      @command = options.fetch(:command)
    end
    
    def current_content(str)
      comm_array = command.split(" ")
      c = IO.popen([*comm_array, "#{str}"]).read
      super(c)
    end
  end
end
