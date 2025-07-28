# frozen_string_literal: true

require_relative "mri_hook/version"
require_relative "mri_hook/api_client"
require_relative "mri_hook/models/resident"
require_relative "mri_hook/models/lease"
require_relative "mri_hook/models/billing_item"
require_relative "mri_hook/models/previous_address"
require_relative "mri_hook/models/pending_move_in"
require_relative "mri_hook/models/ledger_transaction"
require_relative "mri_hook/models/payment"
require_relative "mri_hook/request_handlers/base_handler"
require_relative "mri_hook/request_handlers/residents_by_property_handler"
require_relative "mri_hook/request_handlers/residents_handler"
require_relative "mri_hook/request_handlers/resident_lease_details_by_property_handler"
require_relative "mri_hook/request_handlers/open_charges_handler"
require_relative "mri_hook/request_handlers/pending_move_ins_handler"
require_relative "mri_hook/request_handlers/resident_ledger_handler"
require_relative "mri_hook/request_handlers/payment_submitter_handler"

module MriHook
  class Error < StandardError; end
end
