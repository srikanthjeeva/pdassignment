require "test_helper"
# No need to require 'minitest/mock' anymore, mocha is loaded in test_helper

class UserTest < ActiveSupport::TestCase

  # This setup block runs before each test.
  # We create sample data here that mimics the JSON response from the PagerDuty API.
  setup do
    @user_data = {
      "id" => "P123456",
      "name" => "Jane Doe Smith",
      "email" => "jane.doe@example.com",
      "contact_methods" => [
        { "type" => "email_contact_method", "summary" => "Work Email", "self" => "url_to_email_details" },
        { "type" => "sms_contact_method", "summary" => "Mobile", "self" => "url_to_sms_details" }
      ],
      "time_zone" => "Eastern Time (US & Canada)",
      "color" => "blue"
    }

    @all_users_response = { "users" => [@user_data] }
    @single_user_response = { "user" => @user_data }
  end

  # --- Tests for Class Methods ---

  test ".all creates user objects from the user service" do
    # 1. Create a mock object.
    mock_user_service = mock('user_service')
    # 2. Set an expectation: UserService.new should be called and return our mock.
    UserService.expects(:new).returns(mock_user_service)
    # 3. Set an expectation on the mock: get_all_users should be called and return our sample data.
    mock_user_service.expects(:get_all_users).returns(@all_users_response)

    # 4. Call the method being tested.
    users = User.all

    # 5. Assert the results.
    assert_equal 1, users.size
    assert_instance_of User, users.first
    assert_equal "Jane Doe Smith", users.first.full_name
    assert_equal "P123456", users.first.id

    # No mock.verify needed! Mocha handles it automatically.
  end

  test ".find creates a single user object from the user service" do
    mock_user_service = mock('user_service')
    UserService.expects(:new).returns(mock_user_service)
    # Use .with() to be specific about the arguments.
    mock_user_service.expects(:get_user).with("P123456").returns(@single_user_response)

    user = User.find("P123456")

    assert_instance_of User, user
    assert_equal "Jane Doe Smith", user.full_name
  end

  test ".find returns nil if the user service finds nothing" do
    mock_user_service = mock('user_service')
    UserService.expects(:new).returns(mock_user_service)
    mock_user_service.expects(:get_user).with("NOT_FOUND_ID").returns(nil)

    user = User.find("NOT_FOUND_ID")
    assert_nil user
  end


  # --- Tests for Instance Methods ---

  setup do
    # Create a user instance that we can use to test the instance methods.
    @user = User.new(
      id: "P123456",
      full_name: "Jane Doe Smith",
      contact_methods: [
        { "type" => "email_contact_method", "self" => "url1" },
        { "type" => "sms_contact_method", "self" => "url2" }
      ]
    )
  end

  test "#first_name returns the first part of the full name" do
    assert_equal "Jane", @user.first_name
  end

  test "#last_name returns the remaining parts of the full name" do
    assert_equal "Doe Smith", @user.last_name
  end

  test "#contact_methods_with_details fetches details for each contact method" do
    # We can set expectations directly on the ContactMethod class.
    ContactMethod.expects(:get_details).with("url1").returns({ "details" => "Email Details" })
    ContactMethod.expects(:get_details).with("url2").returns({ "details" => "SMS Details" })

    details = @user.contact_methods_with_details

    assert_equal 2, details.size
    assert_equal "Email Details", details.first[:details]["details"]
    assert_equal "SMS Details", details.last[:details]["details"]
  end

  test "#to_param returns the user's id" do
    assert_equal "P123456", @user.to_param
  end
end

