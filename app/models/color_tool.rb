require 'color'

class ColorTool
  attr_accessor :base
  def initialize(base=nil)
    @colors={}
    @colors[:body]=base||random
  end

  def add_color(name,value=nil)
    @colors[name]=color(value)
  end

  def color(value=nil)
    return @colors[value] if @colors[value]
    case value
    when :random
      random
    when String
      value
    when Array
      random(value[0],value[1])
    else
      random
    end
  end

  #hsb stuff
  def random(hue=nil,brightness=nil)
    Color::HSL.from_fraction(hue||rand, 0.8, brightness||rand_float(0.2,0.32)).html
  end

  def rand_float(min, max)
    rand * (max - min ) + min
  end
end
