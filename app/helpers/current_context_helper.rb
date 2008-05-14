module CurrentContextHelper
  
  def current_account
    return nil unless session[:account_id]
    @__current_account ||= Account.find(session[:account_id])
  end

  def set_current_account(account)
    @__current_account = account
    session[:account_id] = account && account.id
  end

  def logged_in?
    session[:account_id]
  end
end