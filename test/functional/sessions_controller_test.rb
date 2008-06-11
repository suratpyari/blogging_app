require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  def test_new
    get :new
    assert_response :success
  end

  def test_create
    post :create, {:username => users(:surat_pyari).username, :password => "suratpyari"}
    assert_redirected_to dashboard_path
    assert_equal users(:surat_pyari).id, session[:user_id]
  end

  def test_destroy
    post :destroy, {:user_id => 1, :method => :delete}
    assert_redirected_to posts_path
    assert_equal "Thanks for your visit", flash[:msg]
  end

  def test_create_without_username_and_password
    post :create, {:username => "", :password => ""}
    assert_equal "Invalid user/password combination", flash[:msg]
    assert_template 'sessions/new'
  end

  def test_create_with_wrong_password
    post :create, {:username => users(:surat_pyari).username, :password => "wrongpassword"}
    assert_equal "Invalid user/password combination", flash[:msg]
    assert_template 'sessions/new'
  end

  def test_create_for_disabled_user
    post :create, {:username => users(:surat_disable).username, :password => "surat"}
    assert_equal "You cannot login. Your account id disabled. Please contact to administrator", flash[:msg]
    assert_template 'sessions/new'
  end

end
