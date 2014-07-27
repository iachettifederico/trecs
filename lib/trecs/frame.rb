module TRecs
  class Frame
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
  end
end
