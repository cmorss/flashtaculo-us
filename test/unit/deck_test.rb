require File.dirname(__FILE__) + '/../test_helper'

class DeckTest < ActiveSupport::TestCase

  def test_find_public_private
    assert_equal(2, Deck.private.size)
    assert_equal(1, Deck.public.size)
    assert_equal(3, Deck.find(:all).size)
  end
  
  def test_save_icon
    deck = decks(:first_grade_math)
    deck.icon.color = 'yellow'
    deck.save!
    deck.reload
    assert_equal('yellow', deck.icon.color)
  end
end
