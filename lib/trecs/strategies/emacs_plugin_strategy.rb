require "strategies/raw_file_strategy"
require "frame"

module TRecs
  class EmacsPluginStrategy < RawFileStrategy
    def initialize(options={})
      file  = "/tmp/emacs-session-recording.html"
      @file = File.open(file)

      @clock   = options.fetch(:clock) { Time }
      @testing = options.fetch(:testing) { false }

      @width  = 0
      @height = 0
    end

    def perform
      @recording = true
      start_time = clock.now

      frames = {}

      while @recording
        frames[timestamp(clock.now - start_time)] = File.read(@file)
        custom_sleep(recorder.step)
      end

      frames.each do |_, content|
        frame = Frame.new(content: content, format: "html")
        @width = frame.width if frame.width > @width
        @height = frame.height if frame.height > @height
      end

      frames.each do |time, content|
        current_time(time)
        current_content(content)
        current_format("html")
        save_frame
      end
    end

    def current_content(content=nil)
      style   = content.split("\n")
        .join("\\n")[/<style type="text\/css">\\n    <!--\\n      (.+)\\n    -->\\n    <\/style>/, 1]
        .split("\\n      ").join("\n")
        .gsub("body {", "pre.emacs-code {")
      code    = content
        .split("\n").join("<do not compute>")[/\s+<pre>(.+)<\/pre>/, 1]
        .split("<do not compute>").join("\n")
        .gsub(/\/\*.+\*\//, "")
      #.gsub!(/^\s/, "").gsub!(/^(<[^\/]\w+ (\w+=['"][^>]+['"])*>)+ /) {|m| m[-1]=""; m } # clean extra space at the begining of each line

      new_content = "<style>#{style}</style><pre style='border: 2px solid #898989;width: #{@width}ex;height: #{@height}ex' class='emacs-code'>#{code}</pre>"

      super(new_content)
    end
  end
end
