require "recording_strategy"
module TRecs
  class IncrementalStrategy
    attr_reader :message
    attr_accessor :recorder

    def initialize(options={})
      @message = options.fetch(:message)
    end

    def perform
      message.each_char.each_with_object("") do |current_char, current_msg|
        current_msg << current_char

        time    = timestamp_for(current_msg)
        content = current_msg.dup
        recorder.current_frame(time: time, content: content)
      end
    end
    private

    def timestamp_for(message)
      (message.size - 1) * recorder.step
    end
  end
end
