# frozen_string_literal: true

require_relative "mri_hook/version"
require_relative "mri_hook/api_client"
require_relative "mri_hook/models/resident"
require_relative "mri_hook/models/lease"
require_relative "mri_hook/models/billing_item"
require_relative "mri_hook/request_handlers/base_handler"
require_relative "mri_hook/request_handlers/residents_by_property_handler"
require_relative "mri_hook/request_handlers/residents_handler"
require_relative "mri_hook/request_handlers/resident_lease_details_by_property_handler"
require_relative "mri_hook/request_handlers/open_charges_handler"

module MriHook
  class Error < StandardError; end
end
