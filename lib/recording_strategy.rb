module TRecs
  class RecordingStrategy
    def initialize(recorder:)
      @recorder = recorder
    end

    private
    attr_reader :recorder
  end
end
