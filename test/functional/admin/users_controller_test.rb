require File.dirname(__FILE__) + '/../../test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
 
  def test_index_without_login
    get :index
    assert_redirected_to '/'
    assert_equal "Login required", flash[:msg]
  end

  def test_index_login
    get :index, {}, {:user_id => users(:surat_pyari).id}
    assert_response :success
  end

  def test_new_without_login
    get :new
    assert_redirected_to '/'
    assert_equal "Login required", flash[:msg]
  end

  def test_new_with_login_not_admin
    get :new, {}, {:user_id => users(:not_admin).id}
    assert_redirected_to dashboard_path
    assert_equal "You are not an administrator", flash[:msg]
  end

  def test_new_with_login_admin
    get :new, {}, {:user_id => users(:admin).id}
    assert_response :success
  end

  def test_edit_without_login
    get :edit, {:id => users(:surat_pyari).id}
    assert_redirected_to '/'
    assert_equal "Login required", flash[:msg]
  end

  def test_edit_with_invalid_user
    get :edit, {:id => users(:surat_pyari).id}, {:user_id => users(:not_admin).id}
    assert_redirected_to admin_users_path
    assert_equal "You cannot edit this user", flash[:msg]
  end

  def test_edit_with_admin
    get :edit, {:id => users(:surat_pyari).id}, {:user_id => users(:admin).id}
    assert_response :success
  end

  def test_edit_with_valid_user
    get :edit, {:id => users(:surat_pyari).id}, {:user_id => users(:surat_pyari).id}
    assert_response :success
  end

  def test_create_without_login
    post :create, {:user => {:first_name => 'first', :last_name => 'last', :email => "user@test.com", :password => "password", :password_confirmation => "password", :role => 1,
  :username => 'username', :status => 0}}
    assert_redirected_to '/'
    assert_equal "Login required", flash[:msg]
  end

  def test_create_with_login_not_admin
    post :create, {:user => {:first_name => 'first', :last_name => 'last', :email => "user@test.com", :password => "password", :password_confirmation => "password", :role => 1,
  :username => 'username', :status => 0}}, {:user_id => users(:not_admin).id}
    assert_redirected_to dashboard_path
    assert_equal "You are not an administrator", flash[:msg]
  end

  def test_create_with_login_admin
    post :create, {:user => {:first_name => 'first', :last_name => 'last', :email => "user@test.com", :password => "password", :password_confirmation => "password", :role => 1,
  :username => 'username', :status => 0}}, {:user_id => users(:admin).id}
    assert_redirected_to admin_user_path(assigns('user'))
    assert_equal "New user created", flash[:msg]
  end

  def test_create_wrong_parameters
    post :create, {:user => {:first_name => '', :last_name => '', :email => "", :password => "", :password_confirmation => "", :role => 1,
  :username => '', :status => 0}}, {:user_id => users(:admin).id}
    assert_template 'new'
  end

  def test_update_without_login
    post :update, {:id => users(:surat_pyari).id, :user => {:first_name => 'pyari', :last_name => 'surat'}, "_method" => "put"}
    assert_redirected_to '/'
    assert_equal "Login required", flash[:msg]
  end

  def test_update_with_invalid_user
    post :update, {:id => users(:surat_pyari).id, :user => {:first_name => 'pyari', :last_name => 'surat'}, "_method" => "put"}, {:user_id => users(:not_admin).id}
    assert_redirected_to admin_users_path
    assert_equal "You cannot edit this user", flash[:msg]
  end

  def test_update_with_admin
    post :update, {:id => users(:surat_pyari).id, :user => {:first_name => 'pyari', :last_name => 'surat'}, "_method" => "put"}, {:user_id => users(:admin).id}
    assert_redirected_to admin_user_path(assigns('user'))
    assert_equal "username: suratpyari updated", flash[:msg]
  end

  def test_update_with_valid_user
    post :update, {:id => users(:surat_pyari).id, :user => {:first_name => 'pyari', :last_name => 'surat'}, "_method" => "put"}, {:user_id => users(:surat_pyari).id}
    assert_redirected_to admin_user_path(assigns('user'))
    assert_equal "username: suratpyari updated", flash[:msg]
  end

  def test_update_wrong_parameters
    post :update, {:id => users(:surat_pyari).id, :user => {:first_name => '', :last_name => ''}, "_method" => "put"}, {:user_id => users(:admin).id}
    assert_template 'edit'
  end

  def test_destroy_without_login
    post :destroy, {:id => users(:surat_pyari).id, "_method" => "delete"}
    assert_redirected_to '/'
    assert_equal "Login required", flash[:msg]
  end

  def test_destroy_with_login_not_admin
    post :destroy, {:id => users(:surat_pyari).id, "_method" => "delete"}, {:user_id => users(:not_admin).id}
    assert_redirected_to dashboard_path
    assert_equal "You are not an administrator", flash[:msg]
  end

  def test_destroy_by_admin
    post :destroy, {:id => users(:surat_pyari).id, "_method" => "delete"}, {:user_id => users(:admin).id}
    assert_redirected_to admin_users_path
    assert_equal "username: suratpyari deleted", flash[:msg]
  end

  def test_destroy_current_user_by_current_user
    post :destroy, {:id => users(:admin).id, "_method" => "delete"}, {:user_id => users(:admin).id}
    assert_redirected_to admin_users_path
    assert_equal "You can not delete this user", flash[:msg]
  end

  def test_cancel_without_login
    get :cancel
    assert_redirected_to '/'
    assert_equal "Login required", flash[:msg]
  end

  def test_cancel_with_login
    get :cancel, {}, {:user_id => users(:not_admin).id}
    assert_redirected_to admin_users_path
  end
end
