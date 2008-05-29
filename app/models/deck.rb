class Deck < ActiveRecord::Base

  acts_as_taggable
  belongs_to :style  
  has_many :cards
  belongs_to :account
  composed_of :icon, :mapping => [%w(icon_color color), %w(icon_overlay overlay)]
  
  validates_presence_of :style
  validates_presence_of :name
  validates_presence_of :account
  before_save :assign_from_icon
  
  has_finder :private, {
    :conditions => ['public = ?', false]
  }

  has_finder :public, {
    :conditions => ['public = ?', true]
  }

  has_finder :for_library, lambda { |terms| 
    
    { :conditions => ['public = ?', true] }
  }
  
  has_finder :for_account_or_public, lambda { |account| 
    { :conditions => ['public = ? or account_id = ?', true, account.id]}
  }
  
  def assign_from_icon
    self[:icon_overlay] = icon.overlay
    self[:icon_color] = icon.color
  end
end
