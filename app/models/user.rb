class User
    include ActiveModel::Model

    attr_accessor :id, :full_name, :email, :contact_methods, :time_zone, :color

    def self.all
        @users = UserService.new.get_all_users

        @users["users"].map do |user_data|
            full_name = user_data["name"]
            User.new(
                id: user_data["id"],
                full_name: full_name,
                email: user_data["email"],
                contact_methods: user_data["contact_methods"],
                time_zone: user_data["time_zone"],
                color: user_data["color"]
            )
        end
    end

    def self.find(user_id)
        user = UserService.new.get_user(user_id)
        if user
          user = user["user"]
          User.new(
              id: user["id"],
              full_name: user["name"],
              email: user["email"],
              contact_methods: user["contact_methods"],
              time_zone: user["time_zone"],
              color: user["color"]
          )
        else
            nil
        end
    end

    def contact_methods_with_details
        @contact_methods_with_details ||= contact_methods.map do |method|
            {
                type: method["type"],
                summary: method["summary"],
                details: get_contact_method_details(method["self"])
            }
        end
    end


    def get_contact_method_details(url)
        ContactMethod.get_details(url)
    end

    def first_name
        full_name.split(" ").first
    end

    def last_name
        full_name.split(" ")[1..-1].join(" ")
    end

    def to_param
        id
    end
end
