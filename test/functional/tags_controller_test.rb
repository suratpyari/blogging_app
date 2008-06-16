require File.dirname(__FILE__) + '/../test_helper'

class TagsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def test_index
    get :index
    assert :success
  end

  def test_show_wrong_tag
    post :show, {:id => "dfrefhh"}
    assert_redirected_to '/'
    assert_equal "This tag does not exists", flash[:msg]
  end

  def test_show
    post :show, {:id => tags(:tags_001).name}
    assert_response :success
  end

end
