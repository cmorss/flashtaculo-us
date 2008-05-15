class DecksController < ApplicationController
  
  before_filter :find_deck, :except => [:index, :new, :create]
  skip_before_filter :check_for_user, :only => :show
  
  def index
    @decks = Deck.for_library
  end
  
  def new
    @deck = Deck.new(:account_id => session[:account_id])
  end
  
  def create
    @deck = Deck.new(params[:deck].merge(:style_id => Style.default.id))
    if @deck.valid?
      @deck.save!
      redirect_to(deck_path(@deck))
    else
      flash[:error] = @deck.errors.full_messages
      render :template => 'new'
    end
  end
  
  def update
    @deck.update_attributes(params[:deck])
    if @deck.valid?
      @deck.save!
      redirect_to(deck_path(@deck))
    else
      flash[:error] = @deck.errors.full_messages
      render :template => 'edit'
    end    
  end
  
  protected ##################
  
  def find_deck
    context = logged_in? ? Deck.for_account_or_public(current_account) : Deck.public
    @deck = context.find(params[:id]) rescue nil
    unless @deck
      flash[:error] = "We're sorry. We can't seem to find the deck you selected."
      return redirect_to('/')
    end
  end
end
