require 'color'

class ColorTool
  attr_accessor :base
  def initialize(base=nil)
    @base=base||random
  end

  def color(value=nil)
    case value
    when :body
      @base
    when :random
      random
    when String
      value
    when Array
      random(value)
    else
      random
    end
  end

  #hsb stuff
  def random(value=nil)
    Color::HSL.from_fraction(rand, 0.8, rand_float(0.2,0.32)).html
  end

  def rand_float(min, max)
    rand * (max - min ) + min
  end
end
