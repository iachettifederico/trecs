require 'json'
require "yaml"
require "stringio"

module TRecs
  class Source
    attr_reader :manifest

    def initialize(options={})
      @trecs_backend = options.fetch(:trecs_backend)
    end

    def []=(key, value)
      manifest[key] = value
    end

    def [](key)
      manifest[key]
    end

    def manifest
      @manifest ||= {}
    end

  end

  class InMemorySource < Source
    def create_recording
      clear
      trecs_backend[:manifest] = manifest
    end

    def clear
      @trecs_backend.clear
    end

    def add_entry(path)
      io = StringIO.new
      yield io
      io.rewind
      content = io.read.to_s

      path_array = path.split("/") << content
      result = path_array.reverse.inject do |entry, path|
        { path => entry }
      end
      deep_merge(trecs_backend, result)
    end

    def read_entry(path)
      path = path.split("/")

      path.inject(trecs_backend) do |current_tree, current_entry|
        break nil if current_tree.nil?
        current_tree[current_entry]
      end
    end

    private
    attr_reader :trecs_backend

    def deep_merge(hash1, hash2, &block)
      hash2.each_pair do |current_key, other_value|
        this_value = hash1[current_key]

        hash1[current_key] = if this_value.is_a?(Hash) && other_value.is_a?(Hash)
                               deep_merge(this_value, other_value, &block)
                             else
                               if block_given? && key?(current_key)
                                 block.call(current_key, this_value, other_value)
                               else
                                 other_value
                               end
                             end
      end
      hash1
    end

  end
end
