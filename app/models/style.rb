class Style < ActiveRecord::Base
  class << self
    def default
      Style.find_by_name('plain')
    end
  end
end
