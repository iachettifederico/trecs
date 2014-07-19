require "recording_strategies/strategy"
module TRecs
  class TmuxSessionStrategy
    include Strategy
    attr_reader :recording
    attr_reader :step

    def initialize(options={})
      @frames = []
      @step = options.fetch(:step) { 100 } / 1000.0
      @color = options.fetch(:color) { true }
      set_color_or_bw
    end

    def perform
      start_recording
      while(recording)
        command
        system *command
        IO.popen(%W[tmux show-buffer]) do |out|
          recorder.current_frame(content: out.read)
        end
        sleep(step)
      end
    end

    def command
      @command ||=
        set_command
    end

    def set_command
      command = %W[tmux capture-pane]
      command << @color if @color
      command
    end

    def stop
      @recording = false
    end

    private
    def start_recording
      @recording = true
    end

    def set_color_or_bw
      @color = @color ? "-e" : nil
    end
  end
end
