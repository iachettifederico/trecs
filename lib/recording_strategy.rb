module TRecs
  class RecordingStrategy
    def initialize(options={})
      @recorder = options.fetch(:recorder)
    end

    private
    attr_reader :recorder
  end
end
