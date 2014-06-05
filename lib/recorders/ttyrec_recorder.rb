require "timestamps"

require "recorders/zip_file_recorder"
require "recording_strategies/ttyrec_recording_strategy"

module TRecs
  class TtyrecRecorder < ZipFileRecorder
    def initialize(input_file:, output_file:, **options)
      @recording_strategy = TtyrecRecordingStrategy.new(recorder: self, file: input_file)
      super(file_name: output_file, **options)
    end
  end
end
