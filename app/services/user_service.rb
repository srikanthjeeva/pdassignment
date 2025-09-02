require "http"
require_relative "../errors/pager_duty_error"

class UserService
    def initialize
        @headers = { "Accept": "application/json", "Content-Type": "application/json", "Authorization": "Token token=#{APP_CONFIG['token']}" }
    end

    def get_all_users
        make_request { HTTP.get("#{APP_CONFIG['pager_duty_url']}/users", headers: @headers) }
    end

    def get_user(user_id)
        make_request { HTTP.get("#{APP_CONFIG['pager_duty_url']}/users/#{user_id}", headers: @headers) }
    end

    def get_contact_method_details(url)
        make_request { HTTP.get(url, headers: @headers) }
    end

    private

    def make_request
        response = yield
        handle_response(response)
    rescue HTTP::ConnectionError
        raise PagerDutyError.new(503, "Connection failed. Pagerduty API URL is wrong or not reachable.")
    rescue HTTP::TimeoutError
        raise PagerDutyError.new(504, "Request timed out. Please try again.")
    rescue HTTP::Error => e
        raise PagerDutyError.new(500, "HTTP Error: #{e.message}")
    rescue JSON::ParserError
        raise PagerDutyError.new(422, "Invalid JSON response from server")
    end

    def handle_response(response)
        case response.code
        when 200, 201
            JSON.parse(response.body)
        else
            error_data = JSON.parse(response.body)
            raise PagerDutyError.new(
                error_data["code"] || response.code,
                error_data["message"] || "Unknown error occurred"
            )
        end
    end
end
