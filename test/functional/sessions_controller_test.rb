require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase

  def setup
    @controller = SessionController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end

  def test_login_with_good_password
    post(:create, 
         :email => 'micky@disney.com',
         :password => '123456')
         
    assert_redirected_to(:controller => "accounts", 
      :action => 'show', :id => accounts(:micky_mouse).id)
  end
end
