class InitialCreation < ActiveRecord::Migration
  
  def self.up
    create_table "sessions", :force => true do |t|
      t.string    "session_id", :limit => 40
      t.text      "data"
      t.timestamp "updated_on",               :null => false
    end

    create_table :accounts, :force => true do |t|
      t.string   :name, :null => false
      t.string   :email, :null => false
      t.string   :password, :null => false
      t.boolean  :admin, :default => false
      t.timestamps
    end

    create_table :decks, :force => true do |t|
      t.string   :name, :null => false
      t.string   :description
      t.integer  :account_id, :null => false
      t.boolean  :public, :default => false
      t.integer  :style_id, :null => false
      t.string  :icon_color, :null => false
      t.string  :icon_overlay, :null => false
      t.string   :cached_tag_list
      t.timestamps
    end
    
    create_table :subscriptions, :force => true, :id => false do |t|
      t.references :account
      t.references :deck
    end
    
    create_table :styles, :force => true do |t|
      t.string   :name
      t.timestamps
    end
    
    create_table :cards, :force => true do |t|
      t.integer  :deck_id
      t.text     :question
      t.text     :answer
      t.integer  :question_template_id
      t.integer  :answer_template_id
      t.timestamps
    end
    
    create_table :templates, :force => true do |t|
      t.string   :name
      t.text     :liquid_text
      t.timestamps
    end    

    create_table :tags, :force => true do |t|
      t.column :name, :string
    end
    
    create_table :taggings, :force => true do |t|
      t.column :tag_id, :integer
      t.column :taggable_id, :integer
      
      # You should make sure that the column created is
      # long enough to store the required class names.
      t.column :taggable_type, :string
      
      t.column :created_at, :datetime
    end
    
    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type]

    create_table :icons, :force => true do |t|
      t.string :name, :null => false
      t.string :path, :null => false
      t.boolean :default, :default => false
      t.timestamps
    end
    
    root_account = Account.create!(:name => 'root', :admin => true, 
      :email => 'root@flash.com', :password => '123456')
      
    sally_account = Account.create!(:name => 'sally', 
      :email => 'sally@flash.com', :password => '123456')
      
    Account.create!(:name => 'cmorss', :email => 'cmorss@adready.com', :password => '123456')
    Account.create!(:name => 'mookie', :email => 'mookie_moo@gmail.com', :password => '123456')
    Account.create!(:name => 'fred', :email => 'fred@flashme.com', :password => '123456')
    Account.create!(:name => 'maki', :email => 'makie@flashme.com', :password => '123456')

    plain = Style.create!(:name => 'plain')

    root_account.decks.create!(
      :name => '1st Grade Math',
      :description => 'For tiny tots just starting out with their numbers. Basic addition only.',
      :style_id => plain.id,
      :icon => Icon.new(:color => 'magenta', :overlay => 'basic_math'))

    root_account.decks.create!(
      :name => '2st Grade Math',
      :description => 'For bigger tots just starting out with their numbers. Basic addition and subtraction.',
      :style_id => plain.id,
      :public => true,
      :icon => Icon.new(:color => 'blue', :overlay => 'basic_math'))

    capitals_deck = root_account.decks.create!(
      :name => 'USA State capitals',
      :description => 'All 50 states.',
      :style_id => plain.id,
      :icon => Icon.new(:color => 'green', :overlay => 'person'))

    capitals_deck.cards.create!(:question => 'New York',
      :answer => 'Albany')

    capitals_deck.cards.create!(:question => 'California',
      :answer => 'Sacramento')
      
    capitals_deck.cards.create!(:question => 'Alabama',
      :answer => 'Montgomery')

    capitals_deck.tag_list = "usa, us, states, geography, capitals"
    capitals_deck.save!
    
    birds_deck = sally_account.decks.create!(
      :name => 'USA State Birds',
      :description => 'Good luck with this one',
      :public => true,
      :style_id => plain.id,
      :icon => Icon.new(:color => 'yellow', :overlay => 'bird'))

    root_account.subscriptions << birds_deck    
  end
end
