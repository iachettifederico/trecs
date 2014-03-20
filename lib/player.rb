require_relative "timestamps"
require "zip"

module TRecs
  class Player
    include FileUtils

    def initialize(opts={})
      @file_name = opts[:file_name]

      @dir = Dir.mktmpdir(@filename)
      Zip::File.open(@file_name) do |file|
        file.each do |f|
          f.extract "#{@dir}/#{f.name}"
        end
      end

      @current_time = opts[:time]

      @step = opts.fetch(:step) { 100 }

      @ticks = if !opts[:time]
                 ticks
               else
                 Array(opts[:time].to_i)
               end
    end

    def tick(time=current_time)
      self.current_time = time
      frame = File.read(file_to_read)
      yield frame if block_given?
      frame
    end

    def timestamps
      return [] unless file_name
      @timestamps ||=  Dir.glob("#{@dir}/*").each.map do |line|
        line[/\/(\d++)\Z/, 1].to_i
      end.sort
    end

    def ticks
      if @ticks
        return @ticks
      else
        @ticks = [0]
        curr   = 0
        while(curr < timestamps.last.to_i)
          curr += @step
          @ticks << curr
        end
        @ticks
      end
    end

    private
    attr_reader :file_name
    attr_accessor :current_time

    def file_to_read
      file_array = []
      file_array << @dir
      file_array << "/"
      file_array << time_at(current_time)
      file_to_read = file_array.join
    end

    def time_at(time)
      Timestamps.new(timestamps).time_at(time)
    end
  end
end
