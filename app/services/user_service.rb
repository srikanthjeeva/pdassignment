require "http"
require_relative "../errors/pager_duty_error"

class UserService
    def initialize
        @headers = { "Accept": "application/json", "Content-Type": "application/json", "Authorization": "Token token=#{APP_CONFIG['token']}" }
    end

    def get_all_users
        response = make_request { HTTP.get("#{APP_CONFIG['pager_duty_url']}/users", headers: @headers) }
        JSON.parse(response.body)
    end

    def get_user(user_id)
        response = make_request { HTTP.get("#{APP_CONFIG['pager_duty_url']}/users/#{user_id}", headers: @headers) }
        JSON.parse(response.body)
    end

    def get_contact_method_details(url)
        response = make_request { HTTP.get(url, headers: @headers) }
        JSON.parse(response.body)
    end

    private

    def make_request
        begin
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
    end

    def handle_response(response)
        case response.code
        when 200, 201
            response
        else
            error_data = JSON.parse(response.body)
            raise PagerDutyError.new(
                error_data["code"] || response.code,
                error_data["message"] || "Unknown error occurred"
            )
        end
    end
end
