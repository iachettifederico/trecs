module TRecs
  class TtyrecStrategy
    attr_accessor :recorder

    def initialize(options={})
      file = options.fetch(:input_file)
      @file = File.new(file)
      @frames = []
      @full_output = ""
      @height = options.fetch(:height) { 24 }
      @width = options.fetch(:width) { 80 }
    end

    def perform
      @prev_timestamp = 0
      @prev_frame = ""
      while !@file.eof?
        sec, usec, len = @file.read(12).unpack('VVV')
        curr_data = @file.read(len)
        @full_output << curr_data

        data_array  = @full_output.each_line.to_a
        height     = data_array.size > @height ? @height : 0
        frame      = data_array[-height..-1].join

        frame = @prev_frame + curr_data
        
        @first_timestamp ||= [ sec, usec ].join('.').to_f
        curr_timestamp   = [ sec, usec ].join('.').to_f
        offset = ((curr_timestamp - @first_timestamp)*1000).to_i

        if curr_timestamp > @prev_timestamp
          recorder.current_frame(time: offset, content: frame)
          @prev_timestamp = curr_timestamp
          @prev_frame = frame
        end
      end
    end
  end
end

# module TRecs
#   class TtyrecStrategy
#     attr_accessor :recorder

#     def initialize(options={})
#       file = options.fetch(:input_file)
#       @file = File.new(file)
#       @frames = []
#       @full_output = ""
#       @height = options.fetch(:height) { 24 }
#       @width = options.fetch(:width) { 80 }
#     end

#     def perform
#       @prev_timestamp = 0
#       while !@file.eof?
#         sec, usec, len = @file.read(12).unpack('VVV')
#         @full_output << @file.read(len)

#         data_array = @full_output.each_line.to_a
#         height     = data_array.size > @height ? @height : 0
#         frame      = data_array[-height..-1].join

#         @first_timestamp ||= [ sec, usec ].join('.').to_f
#         curr_timestamp   = [ sec, usec ].join('.').to_f
#         offset = ((curr_timestamp - @first_timestamp)*1000).to_i

#         if curr_timestamp > @prev_timestamp
#           recorder.current_frame(time: offset, content: frame)
#           @prev_timestamp = curr_timestamp
#         end
#       end
#     end
#   end
# end
