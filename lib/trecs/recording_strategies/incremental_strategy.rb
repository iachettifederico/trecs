require "recording_strategies/strategy"

module TRecs
  class IncrementalStrategy
    include Strategy

    attr_reader :message

    def initialize(options={})
      @message = options.fetch(:message)
    end

    def perform
      recorder.current_frame(time: 0, content: "")
      message.each_char.each_with_object("") do |current_char, current_msg|
        current_msg << current_char

        current_time(timestamp_for(current_msg))
        current_content(current_msg.dup)
        save_frame
      end
    end

    private

    def timestamp_for(message)
      message.size * recorder.step
    end
  end
end
