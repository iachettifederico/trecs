require "strategies/strategy"
require "sources/tgz_source"
require "player"
require "frame"

module TRecs
  class TrecsFileStrategy
    include Strategy
    attr_reader :input_file
    attr_reader :frames
    attr_reader :from
    attr_reader :to
    attr_reader :speed
    attr_reader :timestamps

    def initialize(options={})
      @input_file = options.fetch(:input_file)

      source = TRecs::TgzSource.new(trecs_backend: input_file)
      @frames = get_frames(source)

      @from  = options.fetch(:from)  { nil }
      @to    = options.fetch(:to)    { nil }
      @speed = options.fetch(:speed)    { nil }
    end

    def perform
      timestamps.each do |time|
        current_time(((time-from)/speed.to_f).to_i)
        current_content(frames[time])
        save_frame
      end
    end


    private

    def timestamps
      @timestamps ||= frames.keys.map(&:to_i).sort
      if from
        @timestamps = @timestamps.select { |t| t > from }
        @timestamps.unshift(from)
      end
      if to && to > 0
        @timestamps = @timestamps.select { |t| t < to }
        @timestamps.push(to)
      end
      @timestamps
    end

    def get_frames(source)
      frames = {}
      source.read do
        json_string = source.read_entry("frames.json") || "{}"
        parsed_json = JSON.parse(json_string, symbolize_names: true)
        parsed_json.each do |time, value|
          frames[Integer(time.to_s)] = Frame(value)
        end
      end
      frames
    end
  end
end
