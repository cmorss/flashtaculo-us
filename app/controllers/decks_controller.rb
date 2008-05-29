class DecksController < ApplicationController
  
  before_filter :find_deck, :except => [:index, :new, :create, :public]
  skip_before_filter :check_for_user, :except => [:public]
  
  def public
    @decks = Deck.for_library(:search_terms => params[:search])
  end
  
  def index
    # View uses current_account collections
  end
  
  def new
    @deck = current_account.decks.build(:icon => Icon.default)
    render :template => 'decks/edit'
  end
  
  def create
    @deck = current_account.decks.create(params[:deck].merge(:style_id => Style.default.id))
    if @deck.valid?
      redirect_to(deck_path(@deck))
    else
      flash[:error] = @deck.errors.full_messages
      render :template => 'new'
    end
  end
  
  def update
    @deck.icon.color = params[:deck_icon_color]
    @deck.icon.overlay = params[:deck_icon_overlay]
    
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
