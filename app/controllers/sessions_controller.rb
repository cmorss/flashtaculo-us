class SessionsController < ApplicationController
  skip_before_filter :check_for_user  
  layout "dialog"
  
  # GET /session/new
  def new; end
  
  # POST /session
  def create
    account = Account.login(params[:email], params[:password])

    if account
      set_current_account(account)
      return redirect_to_page_mark_or_default(
                :controller => :accounts, 
                :action => :show, 
                :id => account.id)
    end

    flash[:error] = "The email address and password you entered did not match " +
                    "any accounts in our system. Please try again."
    redirect_to(:controller => :sessions, :action => :new)    
  end
  
  # DELETE /session
  def destroy
    reset_session
    redirect_to('/')
  end
end
