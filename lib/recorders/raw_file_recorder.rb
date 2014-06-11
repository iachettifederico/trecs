require "timestamps"

require "recorders/zip_file_recorder"
require "recording_strategies/raw_file_recording_strategy"

module TRecs
  class RawFileRecorder < ZipFileRecorder
    def initialize(options={})
      input_file = options.fetch(:input_file)
      output_file = options.fetch(:output_file)

      options[:recorder] = self
      options[:file]     = input_file
      @recording_strategy = RawFileRecordingStrategy.new(options)

       options[:file_name] = output_file
      super(options)
    end
  end
end
