class CardsController < ApplicationController
  before_filter :find_deck
  before_filter :find_card, :only => [:update, :show]
  
  def new
    @card = @deck.cards.build
  end
  
  def create
    @card = @deck.cards.create(params[:card])
    @card.save!    
    flash[:info] = "Card \"#{@card.question}\" - \"#{@card.answer}\" created."
    redirect_to new_deck_card_path(@deck)
  end
  
  def show
  end
  
  def update
  end
  
  def find_deck
    @deck = Deck.find(params[:deck_id])
  end
  
  def find_card
    @card = @deck.cards.find(params[:id])
  end
end
