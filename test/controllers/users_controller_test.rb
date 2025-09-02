require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @valid_user_response = {
      "user" => {
        "id" => "ABCD123",
        "name" => "John Doe",
        "email" => "john@example.com",
        "contact_methods" => [],
        "time_zone" => "UTC",
        "color" => "red"
      }
    }
  end

  test "should get index" do
    # Mock the API call
    UserService.any_instance.stubs(:get_all_users)
               .returns({ "users" => [ @valid_user_response["user"] ] })

    get users_url
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should show user" do
    user_id = "ABCD123"
    UserService.any_instance.stubs(:get_user)
               .with(user_id)
               .returns(@valid_user_response)

    get user_url(user_id)
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test "should handle user not found" do
    user_id = "nonexistent"
    UserService.any_instance.stubs(:get_user)
               .with(user_id)
               .raises(PagerDutyError.new(404, "User not found"))

    get user_url(user_id)
    assert_redirected_to common_error_url
    assert_not_nil flash[:error]
  end
end
