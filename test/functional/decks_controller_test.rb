require File.dirname(__FILE__) + '/../test_helper'

class DecksControllerTest < ActionController::TestCase

  def setup
    @controller = DecksController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end

  def test_new_not_logged_in_redirect
    get(:new)
    assert_response(:redirect)
  end

  def test_new_with_logged_in_user
    @request.session[:account_id] = accounts(:micky_mouse).id
    get(:new)
    assert_response(:success)
  end
  
  def test_not_mine_deck_redirect
    @request.session[:account_id] = accounts(:micky_mouse).id 
    deck = decks(:private_german)
    get(:show, :id => deck.id)
    assert_response(:redirect)    
  end
end

