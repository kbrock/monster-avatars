#know how to use imagemagick to generate a particular avatar
class Avatar
  #These are in a particular order
  ALL_PARTS=[:legs, :hair, :arms, :body, :eyes, :mouth]

  # PARTS_DIR='parts'
  # NUM_PARTS={
  #  :legs  =>  5,
  #  :hair  =>  5,
  #  :arms  =>  5,
  #  :body  => 15,
  #  :eyes  => 15,
  #  :mouth => 10
  # }
  # PARTS_DIR='parts_s'
  # NUM_PARTS={
  #  :legs  =>  13,
  #  :hair  =>  7,
  #  :arms  =>  9,
  #  :body  =>  5,
  #  :eyes  =>  5,
  #  :mouth =>  7
  # }
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
  #   'hair_9.png'   => [  0.6, 0.75], 'arms_7.png'   => [ 0.01, 0.05],
  #   'hair_10.png'  => [ 0.01, 0.05], 'mouth_9.png'  => [ 0.01, 0.05],
  #   'mouth_6.png'  => [ 0.01, 0.05], 'mouth_12.png' => [ 0.01, 0.05],
  #   'arms_1.png' => :white,'arms_2.png' => :white,'arms_9.png' => :white,'arms_10.png' => :white,
  #   'eye_13.png' => :white,
  #   'hair_1.png' => :white,'hair_2.png' => :white,'hair_3.png' => :white,'hair_5.png' => :white,
  #   'legs_4.png' => :white,'legs_S11.png => :white',
  #   'arms_3.png' => :random,'arms_4.png' => :random,'arms_5.png' => :random,'arms_6.png' => :random,'arms_8.png' => :random,'arms_10.png' => :random,'arms_11.png' => :random,
  #   'arms_12.png' => :random,'arms_14.png' => :random,
  #   'hair_6.png'  => :random,'hair_7.png' => :random,'hair_8.png' => :random,'hair_9.png' => :random,
  #   'legs_1.png' => :random,'legs_2.png' => :random,'legs_3.png' => :random,'legs_5.png' => :random,'legs_6.png' => :random,'legs_7.png' => :random,
  #   'legs_8.png' => :random,'legs_9.png' => :random,'legs_11.png' => :random,'legs_12.png' => :random,'legs_15.png' => :random,'legs_17.png' => :random,
  #   'mouth_3.png' => :random,'mouth_4.png' => :random,'mouth_7.png' => :random,'mouth_10.png' => :random,'mouth_16.png' => :random
  #   }

  attr_accessor :filename, :key

  def initialize(key)
    @force = false
    @key = key.to_i
    @filename="#{Rails.root}/tmp/avatar-#{@key}.png"
    #@filename="#{Rails.root}/sample.png"
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

  def open
    `open #{@filename}`
  end

  private
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