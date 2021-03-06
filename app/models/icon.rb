class Icon
  attr_accessor :overlay
  attr_accessor :color
  
  class << self
    def default
      Icon.new(:overlay => 'question', :color => 'blue')
    end
  end
  
  def initialize(*args)
    if Hash === args.first 
      self.overlay = args.first[:overlay]
      self.color = args.first[:color]      
    else
      self.color = args.first
      self.overlay = args.last
    end
  end
  
  def path
    "#{color}_#{overlay}.png"
  end
end
