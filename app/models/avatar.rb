class Avatar
  #These are in a particular order
  ALL_PARTS=[:legs, :hair, :arms, :body, :eyes, :mouth]

  NUM_PARTS={
   :legs  =>  5,
   :hair  =>  5,
   :arms  =>  5,
   :body  => 15,
   :eyes  => 15,
   :mouth => 10
  }

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
      ret=`#{command}`
      raise ret unless ret.blank?
    end
  end

  def cleanup
    `rm #{@filename}`
  end

  def filetype
    'image/png'
  end

  def self.find(id)
    a = Avatar.new(id)
  end

  private
  def command
    part_values=part_files
    "cd #{Rails.root} ; convert parts/background.png " + (ALL_PARTS.collect {|part| part_values[part] } + [@filename]).join(' -composite ')
  end

  def part_files
    part_values={}
    ALL_PARTS.each do |part|
      part_values[part] = "parts/#{part}_#{@key % NUM_PARTS[part]}.png"
    end
    part_values
  end
end