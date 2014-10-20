require "strategies/strategy"
require "strategies/shell_command_strategy"

module TRecs
  class IncrementalStrategy
    include Strategy
    include ShellCommandStrategy

    attr_reader :message
    attr_reader :step

    def initialize(options={})
      @message = options.fetch(:message)
      @command = options.fetch(:command) { nil }
      @step = options.fetch(:step) { 100 }
      
    end

    def perform
      current_time(0)
      current_content("")
      save_frame

      message.each_char.each_with_object("") do |current_char, current_msg|
        current_msg << current_char

        current_time(timestamp_for(current_msg))
        current_content(current_msg.dup)
        save_frame
      end
    end

    private

    def timestamp_for(message)
      message.size * step
    end
  end
end
