class NumberPNG
  module Segments
    # See: https://en.wikipedia.org/wiki/Seven-segment_display
    #                A
    #        [2,1] [3,1] [4,1]
    #   [1,2]                 [5,2]
    # F [1,3]                 [5,3] B
    #   [1,4]        G        [5,4]
    #        [2,5] [3,5] [4,5]
    #   [1,6]                 [5,6]
    # E [1,7]                 [5,7] C
    #   [1,8]                 [5,8]
    #         [2,9 [3,9] [4,9]
    #                D
    A = [[2,1], [3,1], [4,1]]
    B = [[5,2], [5,3], [5,4]]
    C = [[5,6], [5,7], [5,8]]
    D = [[2,9], [3,9], [4,9]]
    E = [[1,6], [1,7], [1,8]]
    F = [[1,2], [1,3], [1,4]]
    G = [[2,5], [3,5], [4,5]]

    DIGIT_TO_SEGMENTS = {
      0 => [A, B, C, D, E, F],
      1 => [B, C],
      2 => [A, B, D, E, G],
      3 => [A, B, C, D, G],
      4 => [B, C, F, G],
      5 => [A, C, D, F, G],
      6 => [A, C, D, E, F, G],
      7 => [A, B, C],
      8 => [A, B, C, D, E, F, G],
      9 => [A, B, C, D, F, G],
    }
  end

  ON_COLOR = ChunkyPNG::Color.rgb(0, 255, 0)
  OFF_COLOR = ChunkyPNG::Color::BLACK
  DIGIT_WIDTH = 7
  DIGIT_HEIGHT = 11

  def initialize(number)
    @digits = number.to_s.chars.map(&:to_i)
    image_width = DIGIT_WIDTH * @digits.size
    @png = ChunkyPNG::Image.new(image_width, DIGIT_HEIGHT, OFF_COLOR)
  end

  def to_png_blob
    offset = 0
    @digits.each do |digit|
      Segments::DIGIT_TO_SEGMENTS.fetch(digit).each do |segments|
        segments.each do |x, y|
          @png[x + offset, y] = ON_COLOR
        end
      end
      offset += DIGIT_WIDTH
    end

    @png.to_datastream.to_blob
  end
end
