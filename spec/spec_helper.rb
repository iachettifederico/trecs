require File.expand_path("../../lib/trecs", __FILE__)

require "rspec/given"
require "ostruct"

require "recorder"
require "writers/in_memory_writer"

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end

class Spy
  attr_reader :calls

  @calls = {}
  @index = 0

  def initialize(name)
    @calls = {}
    @index = 0
    @name = name
    @skips = []
  end

  def self.clear
    @calls = {}
    @index = 0
  end

  def method_missing(method, *args)
    unless @skips.include? method
      @index = @index + 1
      self.class.inc_index

      @calls[@index] = add_call(method, args)
      self.class.add_call(@name, method, args)
    end
  end

  def ignore(*methods)
    methods.each do |method|
      @skips << method
    end
    self
  end
  alias :skip :ignore

  def self.inc_index
    @index = @index + 1
  end

  def add_call(method, args)
    @calls[@index] = [method, args]
  end

  def self.add_call(name, method, args)
    @calls[@index] = [name, method, args]
  end

  def self.calls
    @calls
  end
end

class CustomTicker
  attr_accessor :player
  def initialize(*ticks)
    @ticks = ticks
  end
  def start
    @ticks.each do |time|
      player.tick(time)
    end
  end
end

class CustomReader
  attr_accessor :player
  def initialize(frames={})
    @frames = frames
  end
  def frame_at(n)
    @frames[n]
  end

  def timestamps
    @frames.keys
  end
  def setup
  end
end

# def create_dir(dir_path)
#   mkdir_p dir_path unless File.exist?(dir_path)
#   dir_path
# end

# def file_name(string=nil)
#   if string
#     @file_name = "#{project_dir}/#{string}.trecs"
#   else
#     @file_name
#   end
# end
