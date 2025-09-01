class ContactMethod
    include ActiveModel::Model
    attr_accessor :id, :type, :summary, :address, :country_code

    def self.get_details(url)
        contact_details = UserService.new.get_contact_method_details(url)
        if contact_details && contact_details["contact_method"]
            ContactMethod.new(
                id: contact_details["contact_method"]["id"],
                type: contact_details["contact_method"]["type"],
                summary: contact_details["contact_method"]["summary"],
                address: contact_details["contact_method"]["address"],
                country_code: contact_details["contact_method"]["country_code"]
            )
        else
            nil
        end
    end
end
