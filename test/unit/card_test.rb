require File.dirname(__FILE__) + '/../test_helper'

class CardTest < ActiveSupport::TestCase
  def test_question_index_assignment
    card = Card.new(:question_8 => 'foo')
    assert_equal('foo', card.question[8])
  end

  def test_question_index_getter
    card = Card.new(:question => ['cow', 'pig', 'chicken'])
    assert_equal('pig', card.question[1])
    assert !card.question[20]
  end

end
