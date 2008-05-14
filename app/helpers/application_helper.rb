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

  def set_ghost_text_in_field(dom_id, text)
    javascript_tag("Event.observe(window, 'load', function(event){Forms.ghost('#{dom_id}','#{text}')}, false)")
  end
  
  def flash_for(*topics)    
    content = ''
    topics.collect do |topic|
      content << div(flash[topic], :class => "flash #{topic}") unless flash[topic].blank?
    end
    content
  end
  
  def focus_dom_element_on_page_load(dom_id)
    javascript_tag("Event.observe(window, 'load', function(event){ $('#{dom_id}').focus() }, false)")
  end

  def set_ghost_text_in_field(dom_id, text)
    javascript_tag("Event.observe(window, 'load', function(event){Forms.ghost('#{dom_id}','#{text}')}, false)")
  end
  
  # Renders a rounded, bordered box using the magic of CSS, one big image,
  # and a bunch of extraneous, non-semantic DIVs.
  def roundify(*args, &block)
    options = args.extract_options!
    content = block_given? ? capture(&block) : (args.first || "&nbsp;")

    color = options.delete(:color)
    header = options.delete(:header)
    note = options.delete(:note)
    
    classes = %w(roundify clear)
    classes << color if color
    classes << :plain unless options[:title] or color
    classes << :plain if header
    classes << header if header
    
    r1 = div(options[:title] ?
      h3(options.delete(:title) + span(note, :class => "note"), :class => header) :
      div("", :class => "r3"), :class => "r1")
    
    r2 = div(div(content, :class => :clear), :class => "r2")
    
    options[:class] = merge_css_classes(classes, options[:class])
    rounded = div(r1 + r2, options)
    
    return concat(rounded, block.binding) if block_given?
    rounded
  end

  def merge_css_classes(original, *args)
    classes = (original.is_a?(Array) ? original.collect(&:to_s) : (original || "").to_s.split(/\s+/)).compact
    (classes | args.collect(&:to_s)).join(" ")
  end
end
