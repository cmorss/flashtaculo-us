class Account < ActiveRecord::Base
  has_many :decks
  has_and_belongs_to_many :subscriptions, :class_name => 'Deck', :join_table => 'subscriptions',
                          :foreign_key => 'account_id', :association_foreign_key => 'deck_id'

  validates_presence_of :name, :message => '^Please enter a nickname'
  validates_uniqueness_of :name, :message => '^The nickname you entered is already taken'

  validates_presence_of :password, :message => '^You must specify a password'
  validates_confirmation_of :password, :message => 'should match confirmation'    
  validates_length_of :password, :minimum => 5
  
  validates_format_of :email,
    :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
    :message => "^Please enter a valid email address"
  
  validates_uniqueness_of :email, :message => '^The email address you entered is already in use'
           
  class << self
    def login(email, password)
      find(:first, :conditions => ['email = ? and password = ?',
              email, password])
    end
  end               
end
