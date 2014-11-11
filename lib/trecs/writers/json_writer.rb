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

    def create_frame(options={})
      time    = options.fetch(:time)
      content = options.fetch(:content)
      format  = options[:format]

      frame = {
        format: format,
        content:  content,
      }

      frames[time] = frame
    end

    def render_frames(frames)
      source.create_recording do |source|
        source[:format] = "json"

        frames_hash = frames.each_with_object({}) { |frame, h|
          h[frame.first] = frame.last.to_h
        }

        json_string = frames_hash.to_json

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
