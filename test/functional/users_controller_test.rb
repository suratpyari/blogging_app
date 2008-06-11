require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def test_show
    get :show, :id => users(:surat_pyari).username
    assert_response :success
    assert_template "admin/users/_profile"
  end
end
