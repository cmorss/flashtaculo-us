module PageMarkHelper

  def page_mark_url
    session[:page_mark]
  end

  def page_marked?
    session[:page_mark]
  end
      
  def page_mark_url_or_default(*url_opts)
    session[:page_mark] || url_for(*url_opts)
  end
  
  def set_page_mark(*url_opts)
    session[:page_mark] = url_for(*url_opts)
  end
  
  def clear_page_mark
    session[:page_mark] = nil
  end

  def redirect_to_page_mark
    raise "No page mark defined." unless session[:page_mark]
    redirect_to session.delete(:page_mark)
  end

  def redirect_to_page_mark_or_default(*url_opts)
    page_mark = session[:page_mark]

    session[:page_mark] = nil
    redirect_to(page_mark || url_for(*url_opts))
  end    
end
