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
