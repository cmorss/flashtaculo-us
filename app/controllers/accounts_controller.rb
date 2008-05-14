class AccountsController < ApplicationController
  
  before_filter :find_account, :except => [:index, :new, :create]
  skip_before_filter :check_for_user
  def new
    @account = Account.new
  end
  
  def index
    @accounts = Account.find(:all, :order => 'email')
  end
  
  def create
    @account = Account.new(params[:account])
    if @account.valid?
      @account.save!
      
      # Log in this user
      set_current_account(@account)
      return redirect_to(account_path(@account))
    else
      flash[:error] = @account.errors.full_messages.join('<br>')
      render :template => '/accounts/new'
    end
  end
  
  protected ##################
  
  def find_account
    @account = Account.find(params[:id])
  end
end
