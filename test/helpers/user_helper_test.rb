require "test_helper"

class UserHelperTest < ActionView::TestCase
  # This setup block creates a simple mock object using Struct.
  # This lets us test the `display_contact_info` helper without needing a real object.
  setup do
    @contact_struct = Struct.new(:type, :country_code, :address)
  end

  # --- Tests for show_contact_method ---
  test "show_contact_method formats a simple string" do
    assert_equal "Email Contact Method", show_contact_method("email_contact_method")
  end

  test "show_contact_method formats an SMS string" do
    assert_equal "Sms Contact Method", show_contact_method("sms_contact_method")
  end

  # --- Tests for display_contact_info ---
  test "display_contact_info formats an email correctly" do
    email_contact = @contact_struct.new("email_contact_method", nil, "test@example.com")
    assert_equal "test@example.com", display_contact_info(email_contact)
  end

  test "display_contact_info formats an SMS number correctly" do
    sms_contact = @contact_struct.new("sms_contact_method", "1", "5551234567")
    assert_equal "+1 - 5551234567", display_contact_info(sms_contact)
  end

  test "display_contact_info formats a phone number correctly" do
    phone_contact = @contact_struct.new("phone_contact_method", "44", "2071234567")
    assert_equal "+44 - 2071234567", display_contact_info(phone_contact)
  end

  test "display_contact_info handles nil input gracefully" do
    assert_equal "No contact information available.", display_contact_info(nil)
  end
end
