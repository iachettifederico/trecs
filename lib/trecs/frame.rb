module TRecs
  class Frame
    include Enumerable
    attr_accessor :content
    attr_accessor :format
    def initialize(opts={})
      opts = opts.is_a?(Hash) ? opts : {content: opts}
      @content = opts.fetch(:content) { "" }
      @format  = opts.fetch(:format)  { "raw" }
    end

    def width
      content.each_line.map { |line|
        line.chomp.size
      }.max
    end

    def height
      content.lines.count
    end

    def each
      content.each_line
    end

    def to_s
      content
    end
    alias :to_str :to_s

    def ==(other)
      to_s == other.to_s
    end
  end

  def Frame(opts)
    case opts
    when Frame then opts
    else
      Frame.new(opts)
    end
  end
  module_function :Frame
end
