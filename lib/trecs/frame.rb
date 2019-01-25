module TRecs
  class Frame
    include Enumerable
    attr_accessor :content
    attr_accessor :format

    def initialize(content: "", **options)
      @content = content
      @format  = options[:format] || "raw"
    end

    def width
      widths = raw_text.each_line.map { |line|
        line.chomp.size
      }
      widths.max || 0
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

def Frame(options)
  case options
  when String then TRecs::Frame.new(content: options)
  when TRecs::Frame then options
  else
    TRecs::Frame.new(**options)
  end
end
