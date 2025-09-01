require "test_helper"

class CommonControllerTest < ActionDispatch::IntegrationTest
  test "should get error" do
    get common_error_url
    assert_response :success
  end
end
