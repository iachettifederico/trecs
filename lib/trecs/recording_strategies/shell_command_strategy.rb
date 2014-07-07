module TRecs
  module ShellCommandStrategy
    attr_reader :command
   
    def current_content(str)
      if self.command
        comm = command.gsub(/<frame>/, "\"#{str}\"")
        str = IO.popen(comm).read
      end
      super(str)
    end
  end
end
