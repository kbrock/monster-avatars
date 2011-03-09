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

  PART_COLOR = {
    'arms_13.png'  => :body,
    'legs_6.png'   => :body,
    'legs_18.png'  => :body,
    'mouth_15.png' => :body,
    'mouth_14.png' => :body
  }

  attr_accessor :filename, :key

  def initialize(key)
    @force = false
    @key = key.to_i
    @filename="#{Rails.root}/tmp/avatar-#{@key}.png"
  end

  def generate
    if ! File.exist?(@filename) || @force
      #TODO: start with background - compose everyone ontop of it
      ret=`#{command} 2>&1`
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

  private
  def open
    `open #{@filename}`
    self
  end

  def command
    "cd #{Rails.root} ; convert parts/background.png " + (part_files + [@filename]).join(' -composite ')
  end

  def part_files
    ct = ColorTool.new
    ALL_PARTS.collect do |part|
      part_file = choose_file(part, key)
      color = ct.choose_color(part == :body ? :body : PART_COLOR[part_file])
      if color
        # create a cusom gradient, but make the darkest 40% black - so we end up with an image with color hilights)
        # clut = apply that gradient to our colors
        "\\( #{PARTS_DIR}/#{part_file} \\( -size 10x100 gradient:#{color} -draw 'fill black rectangle 0,0 10,30' \\) -clut \\) "
      else
        "#{PARTS_DIR}/#{part_file}"
      end
    end
  end

  def choose_file(part, key)
    num_parts = NUM_PARTS[part]
    "#{part}_#{@key % num_parts + 1}.png"
  end
end