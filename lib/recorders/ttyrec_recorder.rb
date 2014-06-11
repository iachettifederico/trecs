require "timestamps"

require "recorders/zip_file_recorder"
require "recording_strategies/ttyrec_recording_strategy"

module TRecs
  class TtyrecRecorder < ZipFileRecorder
    def initialize(options={})
      input_file = options.fetch(:input_file)
      output_file = options.fetch(:output_file)

      options[:recorder] = self
      options[:file] = input_file
      @recording_strategy = TtyrecRecordingStrategy.new(options)

      options[:file_name] = output_file
      super(options)
    end
  end
end
