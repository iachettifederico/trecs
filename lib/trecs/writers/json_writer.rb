require "sources/tgz_source"

module TRecs
  class JsonWriter
    attr_accessor :recorder

    attr_reader :frames
    attr_reader :audio_files
    attr_reader :source

    def initialize(options={})
      @source = options.fetch(:source) {
        trecs_backend = options.fetch(:trecs_backend)
        TgzSource.new(trecs_backend: trecs_backend)
      }

      @audio_files = options.fetch(:audio_files) { [] }
      @audio_files = Array(@audio_files)
    end

    def setup
      @frames = {}
    end
 
    def create_frame(options={})
      time    = options.fetch(:time)
      content = options.fetch(:content)
      format  = options.fetch(:format) { nil }
 
      frame = {
        format: format,
        content:  content,
      }
      frame.reject! {|k,v| v.nil?}
      
      frames[time] = frame
    end

    def render
      source.create_recording do |source|
        source[:format] = "json"

        json_string = frames.to_json
        
        source.create_file('frames.json') do |f|
          f.write json_string
        end

        audio_files.each do |file|
          source.add_audio_file(file)
        end
        if audio_files.any?
          source[:default_audio] = audio_files.first
        end
      end
    end

    def add_audio_file(file_name)
      audio_files << file_name
    end
  end
end
