require "zip"
require "recorder"

module TRecs
  class ZipFileRecorder < Recorder
    include FileUtils
    def initialize(file_name:, **options)
      super(**options)
      @file_name = file_name
      delete_file
    end

    private
    attr_reader :file_name
    attr_reader :frames

    # this
    def setup
      @frames = {}
    end

    def render
      Zip::File.open(file_name, Zip::File::CREATE) do |trecs_file|
        frames.each do |timestamp, content|
          Tempfile.open(timestamp.to_s) do |temp_file|
            temp_file.write(content)
            trecs_file.add(timestamp.to_s, temp_file)
          end
        end
      end
    end

    def create_frame
      frames[current_time] = current_content
    end

    def delete_file
      rm file_name if File.exists? file_name
    end
  end
end
