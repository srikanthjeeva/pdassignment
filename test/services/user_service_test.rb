require "test_helper"

class UserServiceTest < ActiveSupport::TestCase
  def setup
    @user_service = UserService.new
    @mock_user_response = {
      "user" => {
        "id" => "P123456",
        "name" => "Test User",
        "email" => "test@example.com",
        "contact_methods" => [],
        "time_zone" => "UTC",
        "color" => "blue"
      }
    }
    @mock_users_response = { "users" => [ @mock_user_response["user"] ] }
    @mock_contact_method_response = {
      "contact_method" => {
        "id" => "PC12345",
        "type" => "email_contact_method",
        "address" => "test@example.com"
      }
    }
  end

  test "get_all_users returns users on successful request" do
    response_mock = mock()
    response_mock.stubs(:code).returns(200)
    response_mock.stubs(:body).returns(@mock_users_response.to_json)
    HTTP.stubs(:get).returns(response_mock)

    users_data = @user_service.get_all_users
    assert_equal @mock_users_response, users_data
  end

  test "get_user returns a user on successful request" do
    response_mock = mock()
    response_mock.stubs(:code).returns(200)
    response_mock.stubs(:body).returns(@mock_user_response.to_json)
    HTTP.stubs(:get).returns(response_mock)

    user_data = @user_service.get_user("P123456")
    assert_equal @mock_user_response, user_data
  end

  test "get_contact_method_details returns contact details on successful request" do
    response_mock = mock()
    response_mock.stubs(:code).returns(200)
    response_mock.stubs(:body).returns(@mock_contact_method_response.to_json)
    HTTP.stubs(:get).returns(response_mock)

    contact_details = @user_service.get_contact_method_details("http://fake.url/contact")
    assert_equal @mock_contact_method_response, contact_details
  end

  test "raises PagerDutyError on HTTP::ConnectionError" do
    HTTP.stubs(:get).raises(HTTP::ConnectionError)

    exception = assert_raises(PagerDutyError) do
      @user_service.get_all_users
    end
    assert_equal 503, exception.code
    assert_match(/Connection failed/, exception.message)
  end

  test "raises PagerDutyError on HTTP::TimeoutError" do
    HTTP.stubs(:get).raises(HTTP::TimeoutError)

    exception = assert_raises(PagerDutyError) do
      @user_service.get_all_users
    end
    assert_equal 504, exception.code
    assert_match(/Request timed out/, exception.message)
  end

  test "raises PagerDutyError on other HTTP::Error" do
    HTTP.stubs(:get).raises(HTTP::Error.new("Some HTTP error"))

    exception = assert_raises(PagerDutyError) do
      @user_service.get_all_users
    end
    assert_equal 500, exception.code
    assert_match(/HTTP Error/, exception.message)
  end

  test "raises PagerDutyError on JSON::ParserError" do
    response_mock = mock()
    response_mock.stubs(:code).returns(200)
    response_mock.stubs(:body).returns("invalid json")
    HTTP.stubs(:get).returns(response_mock)

    exception = assert_raises(PagerDutyError) do
      @user_service.get_all_users
    end
    assert_equal 422, exception.code
    assert_match(/Invalid JSON response/, exception.message)
  end

  test "raises PagerDutyError on API error response" do
    error_response = { "message" => "Not Found", "code" => 2100 }.to_json
    response_mock = mock()
    response_mock.stubs(:code).returns(404)
    response_mock.stubs(:body).returns(error_response)
    HTTP.stubs(:get).returns(response_mock)

    exception = assert_raises(PagerDutyError) do
      @user_service.get_user("nonexistent")
    end
    assert_equal 2100, exception.code
    assert_equal "Not Found", exception.message
  end
end
