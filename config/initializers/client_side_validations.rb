# frozen_string_literal: true

# ClientSideValidations Initializer

# Disabled validators
# ClientSideValidations::Config.disabled_validators = []

# Uncomment to validate number format with current I18n locale
ClientSideValidations::Config.number_format_with_locale = true

# Uncomment the following block if you want each input field to have the validation messages attached.
#
# Note: client_side_validation requires the error to be encapsulated within
# <label for="#{instance.send(:tag_id)}" class="message"></label>

ActionView::Base.field_error_proc = proc do |html_tag, instance|
  if html_tag =~ /^<label/
    %(<div class="field_with_errors">#{html_tag}</div>).html_safe
  else
    %(<div class="field_with_errors">#{html_tag}
      <div class="d-flex align-items-center error_message">
        <i class="fas fa-times-circle m-1" style="color:red"></i>
        <label for="#{instance.send(:tag_id)}" class="message">#{instance.error_message.first}</label>
      </div>
    </div>).html_safe
  end
end
