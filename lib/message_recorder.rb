require "timestamps"
require "zip"

require "recorder"

module TRecs
  class MessageRecorder < Recorder
    include FileUtils

    def initialize(file_name:, message:, **options)
      super(**options)
      @file_name = file_name
      @message   = message

      delete_file
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

    # this
    def create_frame
      frames[current_time] = current_content
    end

    def timestamp_for(message)
      (message.size - 1) * step
    end

    private
    attr_reader :file_name
    attr_reader :message
    attr_reader :frames

    # this
    def start_recording
      @frames = {}
    end

    # this
    def finish_recording
      Zip::File.open(file_name, Zip::File::CREATE) do |trecs_file|
        frames.each do |timestamp, content|
          Tempfile.open(timestamp.to_s) do |temp_file|
            temp_file.write(content)
            trecs_file.add(timestamp.to_s, temp_file)
          end
        end
      end
    end

    def delete_file
      rm file_name if File.exists? file_name
    end
  end
end
