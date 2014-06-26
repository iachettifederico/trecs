module TRecs
  module ShellCommandStrategy
    def current_content(str)
      if command
        comm_array = command.split(" ")
        str = IO.popen([*comm_array, "#{str}"]).read
      end
      super(str)
    end
  end
end
