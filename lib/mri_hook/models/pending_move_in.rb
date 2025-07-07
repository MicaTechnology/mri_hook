# frozen_string_literal: true

module MriHook
  module Models
    class PendingMoveIn
      attr_accessor :resident_name_id, :first_name, :last_name, :property_id, :building_id, :unit_id,
                    :lease_id, :resident_status, :scheduled_move_in_date, :email, :phone,
                    :previous_addresses

      # Initialize a new PendingMoveIn object
      #
      # @param [Hash] params the parameters to initialize the object with
      def initialize(params = {})
        @resident_name_id = params['ResidentID']
        @first_name = params['FirstName']
        @last_name = params['LastName']
        @property_id = params['PropertyID']
        @building_id = params['BuildingID']
        @unit_id = params['UnitID']
        @lease_id = params['LeaseID']
        @resident_status = params['ResidentStatus']
        @scheduled_move_in_date = params['ScheduledMoveInDate']
        @email = params['Email']
        @phone = params['Phone']

        # Handle the nested PreviousAddress objects
        @previous_addresses = []
        if params['PreviousAddress']
          # If there's only one entry, it will be a hash, otherwise it will be an array of hashes
          entries = params['PreviousAddress'].is_a?(Array) ? params['PreviousAddress'] : [params['PreviousAddress']]
          @previous_addresses = entries.map { |entry| MriHook::Models::PreviousAddress.new(entry) }
        end
      end

      # Get the full name of the resident
      #
      # @return [String] the full name
      def full_name
        "#{first_name} #{last_name}".strip
      end

      # Get the primary previous address (first one)
      #
      # @return [MriHook::Models::PreviousAddress, nil] the primary previous address or nil if none exists
      def primary_previous_address
        previous_addresses.first
      end
    end
  end
end
