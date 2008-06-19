require "#{File.dirname(__FILE__)}/../test_helper"

class UserLoginTest < ActionController::IntegrationTest
  fixtures :users

  # Replace this with your real tests.
  def test_user_login
    get "/"
    assert_response :success
    assert_template 'posts/index'

    get_via_redirect '/login'
    assert_response :success
    assert_template 'sessions/new'

    post_via_redirect '/session', {:username => "suratpyari", :password => "suratpyari"}
    assert_equal 1, session[:user_id]
    assert_redirected_to dashboard_path
    assert_template 'admin/dashboard'
  end
end
