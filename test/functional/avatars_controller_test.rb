require File.dirname(__FILE__) + '/../test_helper'

class AvatarsControllerTest < ActionDispatch::IntegrationTest
  test "display image" do
    get avatar_path(55)
    assert_response :success
    assert_equal 55, assigns(:avatar).key
  end
end
