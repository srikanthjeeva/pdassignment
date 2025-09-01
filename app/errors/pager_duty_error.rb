class PagerDutyError < StandardError
    attr_reader :code, :message

    def initialize(code, message)
        @code = code
        @message = message
        super("#{message} (Code: #{code})")
    end
end
