require File.dirname(__FILE__) + '/../../test_helper'

class Admin::BaseControllerTest < ActionController::TestCase

  def test_index_without_user
    get :index
    assert_redirected_to '/'
    assert_equal "Login required", flash[:msg]
  end

  def test_index_with_user
    get :index, {}, {:user_name => users(:surat_pyari).id}
    assert :success
  end

end

