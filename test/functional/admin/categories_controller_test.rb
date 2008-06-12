require File.dirname(__FILE__) + '/../../test_helper'

class Admin::CategoriesControllerTest < ActionController::TestCase

  def test_index_without_user
    get :index
    assert_equal "Login required" ,flash[:msg]
    assert_redirected_to "/"
  end

  def test_index_with_user
    get :index, {:user_id => users(:surat_pyari).id}
    assert :success
  end

  def test_create_without_user
    xhr :post, :create, {:category => {:category_name => 'category to test'}}
    assert_equal "Login required", flash[:msg]
    assert_response :success
  end

  def test_create_with_user_not_admin
    xhr :post, :create, {:category => {:category_name => 'category_to_test'}}, {:user_id => users(:not_admin).id}
    assert_equal "You are not an administrator", flash[:msg]
    assert_response :success
  end

  def test_create_with_user_admin
    xhr :post, :create, {:category => {:category_name => 'category_to_test'}}, {:user_id => users(:admin).id}
    assert_response :success
  end

#  def test_delete_without_user
 #   post :delete, {:selected => [categories(:category1).id.to_s, categories(:category2).id.to_s]}
  #  assert_equal "Login required" ,flash[:msg]
   # assert_redirected_to "/"
  #end

  def test_delete_with_user_not_admin
    post :delete, {:selected => [categories(:category1).id.to_s, categories(:category2).id.to_s]}, :user_id => users(:not_admin).id
    assert_equal "You are not an administrator" ,flash[:msg]
    assert_redirected_to dashboard_path
  end

  def test_delete_with_user_admin
    post :delete, {:selected => [categories(:category1).id.to_s, categories(:category2).id.to_s]}, :user_id => users(:admin).id
    assert_equal "Selected categories has been deleted" ,flash[:msg]
    assert_redirected_to :controller => 'admin/categories', :action => 'index'
  end

  def test_delete_without_selecting_category
    post :delete, {}, :user_id => users(:admin).id
    assert_equal "Select category to delete" ,flash[:msg]
    assert_redirected_to :controller => 'admin/categories', :action => 'index'
  end

  def test_delete_category_uncategorized
    post :delete, {:selected => [categories(:category_uncategorized).id.to_s]}, :user_id => users(:admin).id
    assert_equal "Can not delete category Uncategorized" ,flash[:msg]
    assert_redirected_to admin_categories_path
  end

#  def test_edit_without_user
 #   get :edit, {:id => categories(:category1).id}
  #  assert_equal "Login required" ,flash[:msg]
   # assert_redirected_to "/"
  #end

  def test_edit_with_user_not_admin
    get :edit, {:id => categories(:category1).id}, :user_id => users(:not_admin).id
    assert_equal "You are not an administrator" ,flash[:msg]
    assert_redirected_to dashboard_path
  end

  def test_edit_with_user_admin
    get :edit, {:id => categories(:category1).id}, :user_id => users(:admin).id
    assert_response :success
  end

#  def test_update_without_user
 #   post :update, {:id => categories(:category1).id, :category => {:category_name => 'category_to_test'}}
  #  assert_equal "Login required" ,flash[:msg]
   # assert_redirected_to "/"
  #end

  def test_update_with_user_not_admin
    post :update, {:id => categories(:category1).id, :category => {:category_name => 'category_to_test'}}, :user_id => users(:not_admin).id
    assert_equal "You are not an administrator" ,flash[:msg]
    assert_redirected_to dashboard_path
  end

  def test_update_with_user_admin
    post :update, {:id => categories(:category1).id, :category => {:category_name => 'category_to_test'}}, :user_id => users(:admin).id
    assert_response :success
  end

end

