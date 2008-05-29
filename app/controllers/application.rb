require 'cgi'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  include CurrentContextHelper
  include PageMarkHelper
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '25eb0a2780b33053858979f6f9415f3b'
  
  before_filter :check_for_user
  
  def check_for_user
    unless logged_in?
      flash[:error] = 'The page you are trying to access requires you to be logged in.'
      set_page_mark(request.parameters) if request.get?
      redirect_to new_session_path
    end
  end
  
  def escape(input)
    CGI.escapeHTML(input) rescue input
  end  
end
