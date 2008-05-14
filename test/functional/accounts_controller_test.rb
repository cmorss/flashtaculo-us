require File.dirname(__FILE__) + '/../test_helper'

class AccountsControllerTest < ActionController::TestCase
  
  def setup
    @controller = AccountsController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end

  def test_create_with_good_confirm
    a = Account.find(:first, :conditions => ['email = ?', 'foo@bar.com'])
    assert !a
    
    post(:create, 
         :email => 'foo@bar.com', 
         :password => '123456', 
         :password_confirm => '123456')
         
    a = Account.find(:first, :conditions => ['email = ?', 'foo@bar.com'])
    assert !a
    
  end
end
