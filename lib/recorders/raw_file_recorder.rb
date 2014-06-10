require "timestamps"

require "recorders/zip_file_recorder"
require "recording_strategies/raw_file_recording_strategy"

module TRecs
  class RawFileRecorder < ZipFileRecorder
    def initialize(input_file:, output_file:, **options)
      @recording_strategy = RawFileRecordingStrategy.new(recorder: self, file: input_file, **options)
      super(file_name: output_file, **options)
    end
  end
end
