require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase

  def test_show_valid_user
    get :show, {:id => users(:surat_pyari).username}
    assert_template "admin/users/_profile"
  end

  def test_show_invalid_user
    get :show, {:id => 343546}
    assert_redirected_to posts_path
    assert_equal "User with id 343546 does not exist", flash[:msg]
  end

  def test_send_email_valid_email
    post :send_email, {:email => users(:surat_pyari).email}
    assert_equal "An email has been sent", flash[:msg]
    assert_redirected_to login_path
  end

  def test_send_email_invalid_email
    post :send_email, {:email => "invalid@email.com"}
    assert_select "div#flash", "user with this email does not exist"
    assert_template "forgot_password"
  end
  
  def test_forgot_password
    get :forgot_password
    assert_response :success
  end

  def test_edit_password
    get :edit_password, {:token => "098305600565767"}
    assert_response :success
  end

  def test_edit_password_wrong_token
    get :edit_password, {:token => "09830560056454786890578667"}
    assert_redirected_to login_path
    assert_equal "Wrong token", flash[:msg]
  end

  def test_update_password
    post :update_password, {:token => "098305600565767", :user => {:password => "changedpassword", :password_confirmation => "changedpassword"}}
    assert_equal "password updated", flash[:msg]
    assert_equal nil, assigns["user"].token
    assert_redirected_to login_path
  end

  def test_update_password_wrong_password
    post :update_password, {:token => "098305600565767", :user => {:password => "changedpassword", :password_confirmation => "wrongpassword"}}
    assert_template "edit_password"
  end

  def test_show_user_invalid_user
    get :show, {:id => 3453 }, {:user_id => users(:admin).id}
    assert_equal "User with id 3453 does not exist", flash[:msg]
    assert_redirected_to posts_path
  end

  def test_show_user
    get :show, {:id => users(:surat_pyari).username }
    assert_response :success 
  end

end
