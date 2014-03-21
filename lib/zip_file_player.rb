require "zip"
require "player"

module TRecs
  class ZipFilePlayer < Player
    include FileUtils

    def initialize(file_name: "", **options)
      @file_name = file_name

      create_directory
      extract_file

      super(**options)
    end

    # this
    def get_frame(time)
      File.read(file_to_read(time))
    end

    # this
    def get_timestamps
      return [] unless file_name
      Dir.glob("#{dir}/*").each.map do |line|
        line[/\/(\d++)\Z/, 1].to_i
      end
    end

    private
    attr_reader   :file_name
    attr_reader   :dir

    def file_to_read(time)
      file_array = []
      file_array << @dir
      file_array << "/"
      file_array << time
      file_to_read = file_array.join
    end

    def create_directory
      @dir = Dir.mktmpdir
    end

    def extract_file
      Zip::File.open(file_name) do |file|
        file.each do |f|
          f.extract "#{dir}/#{f.name}"
        end
      end
    end

  end

end
