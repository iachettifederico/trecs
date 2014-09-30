require "strategies/raw_file_strategy"

module TRecs
  class EmacsPluginStrategy < RawFileStrategy
    def initialize(options={}) 
      file  = "/tmp/emacs-session-recording.html"
      @file = File.open(file)

      @clock   = options.fetch(:clock) { Time }
      @testing = options.fetch(:testing) { false }

      current_format(:html)
    end


    def current_content(content=nil)
      content.gsub!(/body {\n/, "pre.trecs-code {\n")
      super(content)
    end
  end
end
