ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "mocha/minitest"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  setup do
    # Disable real HTTP requests in tests as a safeguard.
    # Individual tests should provide their own stubs for expected requests.
    HTTP.stubs(:get).raises("Real HTTP requests are not allowed in tests. Use stubs instead.")
  end
end
