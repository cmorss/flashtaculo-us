# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Gets and sets the current page's title, depending on whether or not
  # a value is passed in. Formats page titles correctly when acting as a getter.
  # Respects the current skin's site display name (if it's available).
  def page_title(title=(unset=true;nil))
    @page_title = title unless unset
    ['Flashtaculo.us', @page_title].compact.join(" | ")
  end

  def root_path 
    '/'
  end
  
  def pluralized_amount(target, count)
    return "no #{target.pluralize}" if count == 0
    return "1 #{target}" if count == 1
    "#{count} #{target.pluralize}"
  end
  
  def humanized_amount(count)
    count == 0 ? 'no' : count 
  end
  
  def logged_in?
    return session[:account_id]
  end
  
  def hide_login?
    @hide_login
  end
  
  def hide_login(hide)
    @hide_login = hide
  end

  def flash_for(*topics)    
    content = ''
    topics.collect do |topic|
      content << div(flash[topic], :class => "flash #{topic}") unless flash[topic].blank?
    end
    content
  end

  def label_for(field, content=nil)
    "<label for='#{field.to_s.split.join("_")}'>#{content || field.to_s.titleize}</label>"
  end
  
  def focus_dom_element_on_page_load(dom_id)
    javascript_tag("Event.observe(window, 'load', " + 
      "function(event){ $('#{dom_id}').focus() }, false)")
  end

  def set_ghost_text_in_field(dom_id, text)
    javascript_tag("Event.observe(window, 'load', " + 
      "function(event){Forms.ghost('#{dom_id}','#{text}')}, false)")
  end

  def icon_tag(icon, opts={})
    image_tag('icons/' + icon.path, opts)
  end
  
  def full_icon_path(icon)
    "/images/icons/#{icon.path}"
  end
  
  def color_blank_tag(color, opts = {})
    image_tag("icons/colors/#{color}.png", opts.reverse_merge(:width => 24, :height => 24))
  end
end
