#know how to use imagemagick to generate a particular avatar
class Avatar
  ASCII_A="A"[0]
  ASCII_a="a"[0]

  #These are in a particular order
  ALL_PARTS=[:legs, :hair, :arms, :body, :eyes, :mouth]

  PARTS_DIR='parts_c'
  NUM_PARTS={
   :legs  =>  18,
   :hair  =>  12,
   :arms  =>  14,
   :body  =>  20,
   :eyes  =>  20,
   :mouth =>  17
  }

  PART_COLORS = {
    :arms => {13 => :body},
    :legs => {6 => :body, 18 => :body},
    :mouth => {15 => :body, 14 => :body}
  }

  attr_accessor :key, :magick, :ct
  delegate :filename, :cleanup, :filetype, :to => :magick
  delegate :body, :color, :to => :ct

  # only passing in a key, the base_color/filename are for testing purposes
  def initialize(key, filename=nil)
    @ct = ColorTool.new(PART_COLORS)
    @key = key
    @parts = @key.is_a?(Numeric) ? self.class.parts_from_int(@key) : self.class.parts_from_string(@key)
    @magick = Magick.new(filename || "#{Rails.root}/tmp/avatar-#{@key}.png",PARTS_DIR)
  end

  def generate(force=false)
    if ! magick.exists? || force
      ret=create_monster
      raise ret unless ret.blank?
    end
    self
  end

  def self.find(id)
    a = Avatar.new(id)
  end

  # private
  # methods used for demo / messing around on the command line

  def create_monster
    magick.reset
    magick.background
    @parts.each do |part,num,color|
      num_parts = NUM_PARTS[part]
      if num_parts
        num = num % num_parts + 1
        color = @ct.color(part,num,color)
        magick.composite(choose_file(part,num)){|cf| cf.bclut(color) }
      end
    end
    magick.run
  end


  private
  # components for commands

  # choose a file for the particular body part
  def choose_file(part, num)
    "#{part}_#{num}.png"
  end

  # an integer key (aka account_id) -> hash for keys
  def self.parts_from_int(key)
    ALL_PARTS.collect do |part|
      #technically -don't need to do the mod here
      [part, key, nil]
    end
  end

  def self.parts_from_string(key)
    key.scan(/../).zip(ALL_PARTS).collect do |value,part|
      num, color = value.scan(/(.)/).map {|x| char_to_int(x.first) }
      [part, num, color/36.0]
    end
  end

  def self.char_to_int(key)
    case key
      when '0'..'9' : key.to_i
      when 'a'..'z' : key[0] - ASCII_a + 10
      when 'A'..'Z' : key[0] - ASCII_A + 10 + 26
      else
        'X'
    end
  end
end