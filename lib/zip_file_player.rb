require "zip"
require "player"

module TRecs
  class ZipFilePlayer < Player
    include FileUtils

    def initialize(file_name: "", **options)
      @file_name = file_name

      @dir = Dir.mktmpdir
      Zip::File.open(@file_name) do |file|
        file.each do |f|
          f.extract "#{dir}/#{f.name}"
        end
      end

      super(**options)
    end

    def get_frame(time)
      File.read(file_to_read)
    end

    def get_timestamps
      return [] unless file_name
      Dir.glob("#{dir}/*").each.map do |line|
        line[/\/(\d++)\Z/, 1].to_i
      end
    end

    private
    attr_reader   :file_name
    attr_reader   :dir

    def file_to_read
      file_array = []
      file_array << @dir
      file_array << "/"
      file_array << time_at(current_time)
      file_to_read = file_array.join
    end
  end

end
