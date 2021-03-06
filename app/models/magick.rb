class Magick
  attr_accessor :filename

  def initialize(filename, parts_dir, background=true)
    @filename = filename
    @parts_dir=parts_dir
    @parts = []
  end

  def reset
    @parts =[]
  end

  def background(background="#{@parts_dir}/background.png")
    if block_given?
      @parts << yield(self)
    elsif background
      @parts << background
    end
    self
  end

  def composite(part_file=nil)
    color = yield(self) if block_given?
    @parts <<
      if color
        # create a cusom gradient, but make the darkest 40% black - so we end up with an image with color hilights)
        # clut = apply that gradient to our colors
        "\\( #{@parts_dir}/#{part_file} #{color} -clut \\) -composite"
      else
        "#{@parts_dir}/#{part_file} -composite"
      end
    self
  end

  def exists?
    File.exist?(@filename)
  end

  def filetype
    'image/png'
  end

  def run
    `cd #{Rails.root} ; convert #{@parts.join(' ')} #{filename} 2>&1`
  end

  def open
    `open #{@filename}`
    self
  end
  
  def cleanup
    `rm #{@filename} 2>&1 > /dev/null`
    self
  end

  #helpers used with composite
  # composite('part_file') { |cf| clut('#112233') }
  def clut(color, width=10, height=100)
    "-size #{height}x#{width} gradient:#{color}"
  end

  def bclut(color, width=10, height=100)
    "\\( #{clut(color,width,height)} -draw 'fill black rectangle 0,0 #{width},#{(height*0.3).to_i}' \\)"
  end
end