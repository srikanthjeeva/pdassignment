require "test_helper"

class CommonControllerTest < ActionDispatch::IntegrationTest
  test "should get error page" do
    get common_error_url
    assert_response :success
    assert_template :error
    assert_select "h1", "An error has occurred"
  end
end
