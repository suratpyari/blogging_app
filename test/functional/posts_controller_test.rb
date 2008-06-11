require File.dirname(__FILE__) + '/../test_helper'
require 'posts_controller'

class PostsControllerTest < ActionController::TestCase

  def test_index
    get :index
    assert_response :success 
  end

  def test_show_published
    get :show, :id => posts(:post_published)
    assert_response :success
  end

  def test_show_unpublished
    get :show, :id => posts(:post_unpublished)
    assert_redirected_to "/"
    assert_equal "This poat is Unpublished", flash[:msg]
  end

  def test_show_unpublished_to_admin
    get :show, {:id => posts(:post_unpublished)}, {:user_id => users(:admin).id}
    assert_response :success
  end

end
