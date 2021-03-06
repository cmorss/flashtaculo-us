var Forms = {
  submit: function(form, options) {
    form = $(form);
    options = $H({}).merge(options);
    
    if (options.get('throbber')) {
      $(options.get('throbber')).show();
    }
    
    Forms.giveUpTheGhosts(form);
    form.submit();
  },
  
  ghost: function(target, text) {
    target = $(target);
    target.ghostText = text;

    if ($F(target).blank()) {
      target.addClassName("ghosted");
      target.value = target.ghostText;
    }
    
    Event.observe(target, "focus", function(event) {
      var target = Event.element(event);
      
      if (Forms.isGhosted(target)) {
        target.value = "";
        target.removeClassName("ghosted");
      }
    });

    Event.observe(target, "blur", function(event) {
      var target = Event.element(event);
      
      if ($F(target).blank()) {
        target.addClassName("ghosted");
        target.value = target.ghostText;
      }
    });    
  },
  
  giveUpTheGhosts: function(form) {
    $(form).getInputs("text").each(function(input) {
      if (Forms.isGhosted(input)) {
        input.value = "";
      }
    });
  },
  
  isGhosted: function(input) {
    return input.ghostText && $F(input) == input.ghostText;
  }
};


var ResizingTextArea = Class.create();

ResizingTextArea.prototype = {
  defaultRows: 1,

  initialize: function(field)
  {
      var field = $(field)
      this.defaultRows = Math.max(field.rows, 1);
      this.resizeNeeded = this.resizeNeeded.bindAsEventListener(this);
      Event.observe(field, "click", this.resizeNeeded);
      Event.observe(field, "keyup", this.resizeNeeded);
  },

  resizeNeeded: function(event)
  {
    var t = Event.element(event);
    var lines = t.value.split('\n');
    var newRows = lines.length;
    var oldRows = t.rows;
    for (var i = 0; i < lines.length; i++)
    {
        var line = lines[i];
        if (line.length * 2 >= t.cols) {
          newRows += Math.floor(line.length * 1.9 / t.cols);
        }
    }
    if (newRows > t.rows) t.rows = newRows;
    if (newRows < t.rows) t.rows = Math.max(this.defaultRows, newRows);
  }
}


Card = {
  numFields: 6, 
 
  initAutoResizing: function() {
    for (index = 0; index <= Card.numFields; index++) {
      new ResizingTextArea('card_question_' + index);
      new ResizingTextArea('card_answer_' + index);
    }
  },
  
  initTemplates: function() {
    var templates = $('templates');
    templates.id = 'templates_answer';
    
    var questions = templates.cloneNode(true);
    questions.id = 'templates_question';
    templates.up().appendChild(questions);
  },
  
  loadTemplate: function(templateName, verb) {
    // Move the currently loaded template to the templates div (which is hidden)
    var templatesStorage = $('templates_' + verb);
    var templateHolder = $('template_' + verb);
    var template = templateHolder.down('div')

    if (template) {
      $('templates_' + verb).appendChild(template);
    }
    
    // Move the template to load to the right spot (in the holder)
    var templateToLoad = templatesStorage.down('div.' + templateName);

    templateHolder.appendChild(templateToLoad);
    
    // Move the fields to this newly displayed template
    var index = 0;
    for (index = 0; index <= Card.numFields; index++) {
      var field_holder = templateToLoad.down('.line_' + index);
      if (field_holder) {
        var field_id = 'card_' + verb + '_' + index;
        field_holder.appendChild($(field_id));
      }
    }
  }
}