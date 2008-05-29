require File.dirname(__FILE__) + '/../test_helper'

class AccountTest < ActiveSupport::TestCase
  def test_add_deck_to_account
    a = accounts(:micky_mouse)
    a.decks.create!(:name => 'My first deck', :style => styles(:plain))
    a.reload
    assert_equal(3, a.decks.size)
  end
  
  def test_login
    a = accounts(:micky_mouse)
    logged_in_account = Account.login(a.email, a.password)
    assert_equal a.email, logged_in_account.email
    assert_equal('micky', a.name)
  end
  
  def test_can_edit_deck
    a = accounts(:micky_mouse)
    assert a.edit_deck?(decks(:private_spanish))
    assert !a.edit_deck?(decks(:private_german))
  end
end
