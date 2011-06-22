#know how to use imagemagick to generate a particular avatar
class Avatar
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

  attr_accessor :filename, :key, :ct
  attr_accessor :magick
  delegate :filename, :delegate, :filetype, :to => :magick

  def initialize(key, base_color=nil, filename=nil)
    @ct = base_color || ColorTool.new(base_color)
    @key = key.to_i
    @parts = self.class.parts_from_int(@key, @ct)
    @magick = Magick.new(filename || "#{Rails.root}/tmp/avatar-#{@key}.png",PARTS_DIR)
  end

  def generate(force)
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
      magick.composite(choose_file(part,num)){|cf| cf.bclut(color) if color}
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
  def self.parts_from_int(key, base_color=nil)
    ct = base_color || ColorTool.new(base_color)
    ALL_PARTS.collect do |part|
      num_parts = NUM_PARTS[part]
      num = key % num_parts + 1
      color = ct.color(part_color(part,num))
      [part, num, color]
    end
  end

  def part_color(part,num,color=:random)
    part == :body ? :body : PART_COLORS[part].try(:[],num)||char_to_int(color)
  end
end