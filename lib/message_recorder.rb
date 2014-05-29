require "timestamps"

require "zip_file_recorder"
require "incremental_recording_strategy"


module TRecs
  class MessageRecorder < ZipFileRecorder
    attr_reader :message

    def initialize(message:, **options)
      @message = message
      @recording_strategy = IncrementalRecordingStrategy.new(recorder: self, message: message)
      super(**options)
    end

  end
end
