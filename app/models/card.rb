class Card < ActiveRecord::Base
  belongs_to :deck
  
  serialize :answer
  serialize :question
  
  def after_initialize
    self.answer ||= []
    self.question ||= []
  end
  
  def method_missing(name, *args)
    # Setter (question_3=)
    if /^(.+)_(\d)=$/ =~ name.to_s
      verb = $1
      index = $2.to_i
      send("#{verb}=", []) unless send(verb)
      send(verb)[index] = args.first

    # Getter (question_3)
    elsif /^(.+)_(\d)$/ =~ name.to_s
      verb = $1
      index = $2.to_i
      send(verb)[index]
    else
      super
    end
  end
end
