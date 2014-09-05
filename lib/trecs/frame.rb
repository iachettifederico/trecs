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
      other = Frame(other)
      to_s == other.to_s && format == other.format
    end
  end

end

def Frame(opts)
  case opts
  when TRecs::Frame then opts
  else
    TRecs::Frame.new(opts)
  end
end
