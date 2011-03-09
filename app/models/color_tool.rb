require 'color'

class ColorTool
  attr_accessor :base
  def initialize(base=nil)
    @base=base||random_color
  end

  def choose_color(value)
    case value
    when :body
      @base
    when :random
      random_color
    when Array
      random_color(value)
    else
      random_color
    end
  end

  #hsb stuff
  def random_color(value=nil)
    Color::HSL.from_fraction(rand, 0.8, rand_float(0.2,0.32)).html
  end

  def rand_float(min, max)
    rand * (max - min ) + min
  end
end
