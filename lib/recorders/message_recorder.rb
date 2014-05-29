require "timestamps"

require "recorders/zip_file_recorder"
require "recording_strategies/incremental_recording_strategy"


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
