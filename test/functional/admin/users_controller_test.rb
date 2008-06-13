require File.dirname(__FILE__) + '/../../test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
 
  def test_index_without_user
    get :index
    assert_redirected_to '/'
    assert_equal "Login required", flash[:msg]
  end

  def test_index_with_user
    get :index, {}, {:user_id => users(:surat_pyari).id}
    assert_response :success
  end
end
