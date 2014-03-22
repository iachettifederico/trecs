require "timestamps"

require "zip_file_recorder"


module TRecs
  class MessageRecorder < ZipFileRecorder
    attr_reader :message

    def initialize(message:, **options)
      @message   = message
      super(**options)
    end

    # this
    def perform_recording
      message.each_char.each_with_object("") do |current_char, current_msg|
        current_msg << current_char

        time    = timestamp_for(current_msg)
        content = current_msg.dup
        current_frame(time: time, content: content) # update current_frame
      end
    end

    def timestamp_for(message)
      (message.size - 1) * step
    end


  end
end
