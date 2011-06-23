require 'color'

class ColorTool
  #these parts have hard coded colors

  # param: the body color
  # param: predefined colors e.g. {:arm => {1 => :body}} == arm 1 needs to be the body color
  def initialize(predefined={})
    @colors={}
    @predefined = predefined
  end

  def body(c)
    color(:body,1,c)
    self
  end

  def color(part, number, value=nil)
    return nil if part.nil?
    #lets remember the color
    #if it is based upon another color, then lets figure out that color first
    @colors[part]||=color(predefined(part,number),number,value)||
    case value
    when :random
      random
    when String
      value
    when Numeric
      random(value)
    when Array
      random(value[0],value[1])
    else
      random
    end
  end

  #used for testing. will pass in values to initialize
  def predefine(part, number, other_part)
    (@predefined[part]||={})[number]=other_part
  end

  def predefined(part, number)
    @predefined[part].try(:[],number)
  end

  #hsb stuff
  def random(hue=nil, brightness=nil)
    Color::HSL.from_fraction(hue||rand, 0.8, brightness||rand_float(0.2,0.32)).html
  end

  def rand_float(min, max)
    rand * (max - min ) + min
  end
end
