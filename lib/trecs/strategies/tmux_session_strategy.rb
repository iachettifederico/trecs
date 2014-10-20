require "strategies/strategy"

module TRecs
  class TmuxSessionStrategy < Strategy
    attr_reader :recording

    def initialize(options={})
      super(options)
      @frames = []
      @step = @step / 1000.0
      @color = options.fetch(:color) { true }
      set_color_or_bw
    end

    def perform
      start_recording
      while(recording)
        get_frames do |frame|
          recorder.current_frame(content: frame)
        end
        sleep(step)
      end
    end

    def command
      @command ||=
        set_command
    end

    def stop
      @recording = false
    end

    private
    def start_recording
      @recording = true
    end

    def set_color_or_bw
      @color = @color ? "-e" : "-C"
    end

    def set_command
      command = %W[tmux capture-pane]
      command << @color if @color
      command
    end

    def get_frames
      system *command
      IO.popen(%W[tmux show-buffer]) do |out|
        yield out.read
      end
    end
  end
end
