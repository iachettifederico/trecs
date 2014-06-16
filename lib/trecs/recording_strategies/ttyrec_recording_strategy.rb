require "recording_strategy"
module TRecs
  class TtyrecRecordingStrategy < RecordingStrategy
    def initialize(file:, height: 24, width: 80, **options)
      @file = File.new(file)
      @frames = []
      @full_output = ""
      @height = height
      @width = width
      super
    end

    def perform
      while !@file.eof?
        sec, usec, len = @file.read(12).unpack('VVV')
        @full_output << @file.read(len)

        data_array = @full_output.each_line.to_a
        height     = data_array.size > @height ? @height : 0
        frame       = data_array[-height..-1].join

        prev_timestamp ||= [ sec, usec ].join('.').to_f
        curr_timestamp   = [ sec, usec ].join('.').to_f
        offset = ((curr_timestamp - prev_timestamp)*1000).to_i

        recorder.current_frame(time: offset, content: frame)
      end
    end
  end
end
