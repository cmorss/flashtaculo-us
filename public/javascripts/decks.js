// Javascript for decks controller

Decks = {
  
  currentColor: 'blue',
  placeholderHeight: 0, 
  
  switchColor: function(color, position) {
    new Effect.Appear($('icon_pallete_' + color), {duration: 0.25});
    new Effect.Fade($('icon_pallete_' + Decks.currentColor), {duration: 0.25});
    Decks.currentColor = color;
  },

  startIconEditing: function() {
    new Effect.Fade($('name_div'),  {duration: 0.25});
    new Effect.Appear($('icons'),   {delay: 0.2, duration: 0.25});
    
    Decks.placeholderHeight = $('placeholder').getStyle('height');
    
    // Grow the placeholder that is "under (in z-index)" the name 
    // and icons divs to make room for the icons
    new Effect.Morph('placeholder', {style:'height: 100px', duration: 0.25});

    // Disable and dim out the form
    new Effect.Morph('lower_edits', {style:'color: #aaa', duration: 0.25});    
    $('edit_form').disable();

    var input_morph = {style:'background-color: #eee; color: #dadada', 
                       duration: 0.25};
                       
    new Effect.Morph('deck_name', input_morph);                
    new Effect.Morph('deck_tag_list', input_morph);                
    new Effect.Morph('deck_description', input_morph);                
    
    $('change_link').hide();
    $('finished_link').show();        
  },

  endIconEditing: function() {
    new Effect.Appear($('name_div'), {duration: 0.25});
    new Effect.Fade($('icons'), {duration: 0.25});
    
    // Shrink the placeholder back to its pre-icon editing size.
    new Effect.Morph('placeholder', 
      {style: 'height: ' + Decks.placeholderHeight, duration: 0.25});
        
    new Effect.Morph('lower_edits', {style:'color: #000', duration: 0.25});

    $('edit_form').enable();
    
    var input_morph = {style:'background-color: #fff; color: #000', 
                       duration: 0.25};

    new Effect.Morph('deck_name', input_morph);                
    new Effect.Morph('deck_tag_list', input_morph);                
    new Effect.Morph('deck_description', input_morph);                
  
    $('change_link').show();
    $('finished_link').hide();
  },

  iconSelected: function(path, color, overlay) {
    $('icon_image').src = path;
    $('deck_icon_color').value = color;
    $('deck_icon_overlay').value = overlay;
  }
}