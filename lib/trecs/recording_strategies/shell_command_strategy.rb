module TRecs
  module ShellCommandStrategy
    attr_reader :command
   
    def current_content(str)
      if self.command
        comm_array = command.split(" ")
        str = IO.popen([*comm_array, "#{str}"]).read
      end
      super(str)
    end
  end
end
