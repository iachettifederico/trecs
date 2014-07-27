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
  end
end
