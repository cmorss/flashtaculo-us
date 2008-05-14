class MetaController < ApplicationController
  skip_before_filter :check_for_user  
  
  def home
    @decks = Deck.public.find(:all, :order => 'created_at desc')
  end
end
