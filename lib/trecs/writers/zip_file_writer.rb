require "zip"
require "recorder"

module TRecs
  class ZipFileRecorder
    attr_accessor :recorder

    include FileUtils
    def initialize(options={})
      @file_name = options.fetch(:file_name)
      delete_file
    end

    
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
      frames[recorder.current_time] = recorder.current_content
    end

    private
    attr_reader :frames

    def delete_file
      rm file_name if File.exists? file_name
    end
  end
end
