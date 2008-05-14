require File.dirname(__FILE__) + '/../test_helper'

class DeckTest < ActiveSupport::TestCase

  def test_find_public_private
    assert_equal(1, Deck.private.size)
    assert_equal(1, Deck.public.size)
    assert_equal(2, Deck.find(:all).size)
  end
end
