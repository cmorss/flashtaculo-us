class Deck < ActiveRecord::Base

  acts_as_taggable
  
  belongs_to :style  
  has_many :cards
  belongs_to :account
  
  validates_presence_of :style
  validates_presence_of :name
  validates_presence_of :account
  
  has_finder :private, {
    :conditions => ['public = ?', false]
  }

  has_finder :public, {
    :conditions => ['public = ?', true]
  }

  has_finder :for_library, {
    :conditions => ['public = ?', true]
  }
  
  has_finder :for_account_or_public, lambda { |account| 
    { :conditions => ['public = ? or account_id = ?', true, account.id]}
  }
end
