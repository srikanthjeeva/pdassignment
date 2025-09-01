module UserHelper

  def show_contact_method(contact_type)
    contact_type.split("_").map(&:capitalize).join(" ")
  end

  def display_contact_info(contact_details)
    if contact_details 
      if contact_details.type.match?(/sms|phone/)
      "+#{contact_details.country_code} - #{contact_details.address}"
      else
        contact_details.address
      end
    else
      "No contact information available."
    end
  end
end
