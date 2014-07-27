module TRecs
  class Frame
    include Enumerable
    attr_accessor :content
    def initialize(content="")
      @content = content
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
  end

  def Frame(value)
    case value
    when Frame then value
    else
      Frame.new(value.to_str)
    end
  end
  module_function :Frame
end
