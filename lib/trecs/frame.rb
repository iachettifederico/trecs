module TRecs
  class Frame
    include Enumerable
    attr_accessor :content
    attr_accessor :format
    def initialize(opts={})
      opts = opts.is_a?(Hash) ? opts : {content: opts}
      @content = opts.fetch(:content) { "" }
      @format  = opts[:format] || "raw"
    end

    def width
      raw_text.each_line.map { |line|
        line.chomp.size
      }.max
    end

    def height
      raw_text.lines.count
    end

    def each
      content.each_line
    end

    def to_s
      content
    end
    alias :to_str :to_s

    def to_h
      {
        content: content,
        format: format
      }
    end

    def ==(other)
      other = Frame(other)
      to_s == other.to_s && format == other.format
    end


    def raw_text
      @raw_text = if format == "html"
                    content.split("\n").join("\\n").gsub(/<style>.+<\/style>/, "").gsub("\\n", "\n").gsub(%r{</?[^>]+?>}, '')
                  else
                    content
                  end
    end
    private
  end

end

def Frame(opts)
  case opts
  when TRecs::Frame then opts
  else
    TRecs::Frame.new(opts)
  end
end
