require "strategies/strategy"
require "strategies/shell_command_strategy"

module TRecs
  class HashStrategy
    include Strategy
    include ShellCommandStrategy
    attr_accessor :frames

    def initialize(frames={})
      @frames = frames || Hash.new
      @command = frames.fetch(:command) { nil }
    end

    def perform
      @frames.each do |time, content|
        if time.is_a?(Numeric) || /\A\d+\Z/ === time
          current_time(time.to_s.to_i)
          current_content(content)
          save_frame
        end
      end
    end

    def stop
    end

    def inspect
      "<#{self.class}: frames: #{frames}>"
    end
  end
end
