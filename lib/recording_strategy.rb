module TRecs
  class RecordingStrategy
    def initialize(recorder:, **optionsx)
      @recorder = recorder
    end

    private
    attr_reader :recorder
  end
end
