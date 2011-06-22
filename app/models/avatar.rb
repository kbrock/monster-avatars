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

  def initialize(key, base_color=nil, filename=nil)
    @ct = base_color || ColorTool.new(base_color)
    @key = key.to_i
    @parts = self.class.parts_from_int(@key, @ct)
    @filename= filename || "#{Rails.root}/tmp/avatar-#{@key}.png"
  end

  def generate(force=false)
    if ! File.exist?(@filename) || force
      ret=create_monster(@filename)
      raise ret unless ret.blank?
    end
    self
  end

  def cleanup
    `rm #{@filename} 2>&1 > /dev/null`
    self
  end

  def filetype
    'image/png'
  end

  def self.find(id)
    a = Avatar.new(id)
  end

  # private
  # methods used for demo / messing around on the command line

  def create_monster(filename)
    run(merge_parts,filename)
  end

  def create_clut_file(filename, part=nil)
    run(clut_file(@ct.color(part)), filename)
  end

  def create_black_clut_file(filename, part=nil)
    run(black_clut_file(@ct.color(part)), filename)
  end

  # typically called in rails console via: Avatar.find(55).cleanup.generate.open
  def open
    `open #{@filename}`
    self
  end

  private
  # components for commands

  def run(cmd, filename)
    `cd #{Rails.root} ; convert #{cmd} #{filename} 2>&1`
  end

  def clut_file(color)
    "-size 10x100 gradient:#{color}"
  end

  def black_clut_file(color)
    "\\( -size 10x100 gradient:#{color} -draw 'fill black rectangle 0,0 10,30' \\)"
  end

  def merge_parts
    "parts_c/background.png " + (part_files + ['']).join(' -composite ')
  end

  def part_files
    @parts.collect do |part,num,color|
      part_file = choose_file(part, num)
      #body always gets the body color, some other parts get the body color, but most pass nil (aka random)
      if color
        # create a cusom gradient, but make the darkest 40% black - so we end up with an image with color hilights)
        # clut = apply that gradient to our colors
        "\\( #{PARTS_DIR}/#{part_file} #{black_clut_file(color)} -clut \\) "
      else
        "#{PARTS_DIR}/#{part_file}"
      end
    end
  end

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
      color = ct.color(part == :body ? :body : PART_COLORS[part].try(:[],num))
      [part, num, color]
    end
  end

  def self.parts_from_string(key)
  end
end