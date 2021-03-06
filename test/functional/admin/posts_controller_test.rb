require File.dirname(__FILE__) + '/../../test_helper'

class Admin::PostsControllerTest < ActionController::TestCase

  fixtures :users, :posts

  def test_new_without_user
    get :new
    assert_redirected_to '/'
    assert_equal "Login required", flash[:msg]
  end

  def test_new_with_user
    get :new, {}, {:user_id => users(:surat_pyari).id}
    assert :success
    assert_template 'new'
  end

  def test_index_without_login
    get :index
    assert_redirected_to '/'
    assert_equal "Login required", flash[:msg]    
  end

  def test_index_with_login
    get :index, {}, {:user_id => users(:surat_pyari).id}
    assert :success
  end

  def test_create_without_user
    post :create
    assert_redirected_to '/'
    assert_equal "Login required", flash[:msg]
  end

  def test_create_with_user
    post :create, {:post => {:title => 'title', :content => 'content', :status => 1, :parmalink => 'parmalink'}, :tag => {:name =>"tag1 tag2"}}, {:user_id => users(:surat_pyari).id}
    #p post_path(assigns["post"].id).to_s
    #assert_redirected_to post_path(assigns["post"])
    assert_equal "new post created", flash[:msg]
  end

  def test_create_without_post
    post :create, {:post => {}, :tag => {}}, {:user_id => users(:surat_pyari).id}
    assert_template 'admin/posts/new'
  end

  def test_destroy_without_user
    post :destroy, {:id => posts(:post1).id, '_method' => 'delete'}
    assert_redirected_to '/'
    assert_equal "Login required", flash[:msg]
  end

  def test_destroy_not_a_valid_user
    post :destroy, {:id => posts(:post1).id, '_method' => 'delete'}, {:user_id => users(:not_admin).id}
    #assert_redirected_to :controller => "/posts", :action => "show"
    assert_equal "You can not edit/ destroy this post as it is not created by you", flash[:msg]
  end

  def test_destroy_valid_user_not_admin
    post :destroy, {:id => posts(:post1).id, '_method' => 'delete'}, {:user_id => posts(:post1).user_id}
    assert_equal "#{posts(:post1).title} deleted", flash[:msg]
    assert_redirected_to admin_posts_path
  end

  def test_destroy_by_admin
    post :destroy, {:id => posts(:post1).id, '_method' => 'delete'}, {:user_id => users(:admin).id}
    assert_equal "title1 deleted", flash[:msg]
    assert_redirected_to admin_posts_path
  end

  def test_destroy_wrong_post
    post :destroy, {:id => 89088, '_method' => 'delete'}, {:user_id => users(:admin).id}
    assert_equal "Post with this id does not exist", flash[:msg]
    assert_redirected_to dashboard_path
  end

  def test_edit_without_user
    get :edit, {:id => posts(:post1).id}
    assert_redirected_to '/'
    assert_equal "Login required", flash[:msg]
  end

  def test_edit_not_a_valid_user
    get :edit, {:id => posts(:post1).id}, {:user_id => users(:not_admin).id}
    assert_equal "You can not edit/ destroy this post as it is not created by you", flash[:msg]
  end

  def test_edit_valid_user_not_admin
    get :edit, {:id => posts(:post1).id}, {:user_id => posts(:post1).user_id}
    assert_template 'edit'
  end

  def test_edit_by_admin
    get :edit, {:id => posts(:post1).id}, {:user_id => users(:admin).id}
    assert_template 'edit'
  end

  def test_edit_wrong_post
    get :edit, {:id => 89798}, {:user_id => users(:admin).id}
    assert_equal "Post with this id does not exist", flash[:msg]
    assert_redirected_to dashboard_path
  end

  def test_update_without_user
    post :update,  {:id => posts(:post1).id, :post => {:title => "Changed post title", :content => "Changed post content"}, '_method' => 'put'}
    assert_redirected_to '/'
    assert_equal "Login required", flash[:msg]
  end 

  def test_update_not_a_valid_user
    post :update,  {:id => posts(:post1).id, :post => {:title => "Changed post title", :content => "Changed post content"}, '_method' => 'put'}, {:user_id => users(:not_admin).id}
    assert_equal "You can not edit/ destroy this post as it is not created by you", flash[:msg]
  end

  def test_update_valid_user_not_admin
    post :update,  {:id => posts(:post1).id, :post => {:title => "Changed post title", :content => "Changed post content"}, '_method' => 'put'} , {:user_id => posts(:post1).user_id}
    assert_equal "Post updated", flash[:msg]
  end
  
  def test_update_by_admin
    post :update,  {:id => posts(:post1).id, :post => {:title => "Changed post title", :content => "Changed post content"}, '_method' => 'put'} , {:user_id => users(:admin).id}
    assert_equal "Post updated", flash[:msg]
  end

  def test_update_without_post
    post :update, {:id => posts(:post1).id, :post => {:title => ""}, '_method' => 'put'}, {:user_id => users(:surat_pyari).id}
    assert_template 'edit'
  end

  def test_update_wrong_post
    post :update, {:id => 89798, '_method' => 'put'}, {:user_id => users(:admin).id}
    assert_equal "Post with this id does not exist", flash[:msg]
    assert_redirected_to dashboard_path
  end

  def test_show_without_login
    post :show, {:id => posts(:post1).parmalink}
    assert_redirected_to "/"
    assert_equal "Login required", flash[:msg]
  end

  def test_show_unpublished_post_wrong_user
    post :show, {:id => posts(:post_unpublished).parmalink}, {:user_id => users(:not_admin).id}
    assert_redirected_to admin_posts_path
    assert_equal "This is an unpublished post", flash[:msg]
  end

  def test_show_unpublished_post_with_admin
    post :show, {:id => posts(:post_unpublished).parmalink}, {:user_id => users(:admin).id}
    assert_response :success
  end

  def test_show_unpublished_post
    post :show, {:id => posts(:post_unpublished).parmalink}, {:user_id => users(:surat_pyari).id}
    assert_response :success
  end

  def test_show_published_post
    post :show, {:id => posts(:post1).parmalink}, {:user_id => users(:not_admin).id}
    assert_response :success
  end

end
