require File.dirname(__FILE__) + '/../test_helper'
require 'posts_controller'

class PostsControllerTest < ActionController::TestCase

  def test_index
    get :index
    assert_response :success 
  end

  def test_show_published
    get :show, :id => posts(:post_published).parmalink
    assert_response :success
  end

  def test_show_unpublished
    get :show, :id => posts(:post_unpublished).parmalink
    assert_redirected_to "/"
    assert_equal "This post is Unpublished", flash[:msg]
  end

  def test_show_wrong_post
    get :show, :id => "adsffads"
    assert_redirected_to dashboard_path
    assert_equal "Post with this id does not exist", flash[:msg]
  end

end
