class Deck < ActiveRecord::Base

  acts_as_taggable
  
  belongs_to :style
  validates_presence_of :style

  validates_presence_of :name
  
  has_many :cards
  has_finder :private, {
    :conditions => ['public = 0']
  }

  has_finder :public, {
    :conditions => ['public = 1']
  }

  has_finder :for_library, {
    :conditions => ['public =1']
  }
end
