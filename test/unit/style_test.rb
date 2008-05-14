require File.dirname(__FILE__) + '/../test_helper'

class StyleTest < ActiveSupport::TestCase

  def test_default
    assert_equal('plain', Style.default.name)
  end
end
