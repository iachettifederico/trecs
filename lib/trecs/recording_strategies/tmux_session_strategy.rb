require "recording_strategies/strategy"
module TRecs
  class TmuxSessionStrategy
    include Strategy
    attr_reader :recording
    attr_reader :step

    def initialize(options={})
      @frames = []
      @step = options.fetch(:step) { 100 } / 1000.0
    end

    def perform
      start_recording
      while(recording)
        system *%W[tmux capture-pane -e]
        IO.popen(%W[tmux show-buffer]) do |out|
          recorder.current_frame(content: out.read)
        end
        sleep(step)
      end
    end

    def stop
      @recording = false
    end
    private
    def start_recording
      @recording = true
    end

  end
end
