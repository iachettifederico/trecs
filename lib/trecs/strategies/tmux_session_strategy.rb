require "strategies/strategy"

module TRecs
  class TmuxSessionStrategy < Strategy
    attr_reader :recording

    def initialize(options={})
      super(options)
      # @frames = []
      @step = options.fetch(:step) { 100 }
      @color = options.fetch(:color) { true }
      set_color_or_bw
    end

    def perform
      start_recording
      t = -step
      while(recording)
        t += step
        current_time(t)
        current_content(get_current_frame)
        save_frame
        sleep(step/1000.0)
      end
    end

    def capture_command
      @capture_command ||= set_capture_command
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

    def set_capture_command
      capture_command = %W[tmux capture-pane]
      capture_command << @color if @color
      capture_command
    end

    def get_current_frame
      system *capture_command
      IO.popen(%W[tmux show-buffer]).read
    end
  end
end
