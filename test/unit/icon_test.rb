require File.dirname(__FILE__) + '/../test_helper'

class IconTest < ActiveSupport::TestCase

  def test_constructor
    i = Icon.new(:color => 'green', :overlay => 'fish')
    assert_equal 'fish', i.overlay
    assert_equal 'green', i.color

    b = Icon.new('red', 'bird')
    assert_equal 'bird', b.overlay
    assert_equal 'red', b.color    
  end
end
