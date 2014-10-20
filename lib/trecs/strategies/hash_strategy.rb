require "strategies/strategy"
require "strategies/shell_command_strategy"

module TRecs
  class HashStrategy < Strategy
    include ShellCommandStrategy
    attr_accessor :frames_to_save

    def initialize(frames_to_save={})
      @frames_to_save = frames_to_save || Hash.new
      @command        = frames_to_save.fetch(:command) { nil }
    end

    def perform
      @frames_to_save.each do |time, content|
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
