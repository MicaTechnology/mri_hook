# frozen_string_literal: true

module MriHook
  module Models
    class Lease
      attr_accessor :resident_name_id, :property_id, :building_id, :unit_id, :lease_id,
                    :address, :building_address, :city, :state, :zipcode,
                    :first_name, :last_name, :resident_status, :email, :birthday,
                    :lease_start, :occupy_date, :lease_end, :lease_monthly_rent_amount,
                    :lease_move_out, :lease_month_to_month, :pay_allowed, :last_update_date,
                    :curr_code, :lease_balance, :is_current, :block_e_payments, :guarantor,
                    :lease_term, :number_of_garages, :date_notified, :vacate_reason,
                    :number_of_units, :description, :has_pet, :resident_vacate_date,
                    :number_of_occupants, :name_group, :phone_number, :no_checks_in_web_cash_receipts,
                    :cell_phone_number, :scrie_lease, :minor

      # Initialize a new Lease object
      #
      # @param [Hash] params the parameters to initialize the object with
      def initialize(params = {})
        @resident_name_id = params['ResidentNameID']
        @property_id = params['PropertyID']
        @building_id = params['BuildingID']
        @unit_id = params['UnitID']
        @lease_id = params['LeaseID']
        @address = params['Address']
        @building_address = params['BuildingAddress']
        @city = params['City']
        @state = params['State']
        @zipcode = params['Zipcode']
        @first_name = params['FirstName']
        @last_name = params['LastName']
        @resident_status = params['ResidentStatus']
        @email = params['Email']
        @birthday = params['Birthday']
        @lease_start = params['LeaseStart']
        @occupy_date = params['OccupyDate']
        @lease_end = params['LeaseEnd']
        @lease_monthly_rent_amount = params['LeaseMonthlyRentAmount']
        @lease_move_out = params['LeaseMoveOut']
        @lease_month_to_month = params['LeaseMonthToMonth']
        @pay_allowed = params['PayAllowed']
        @last_update_date = params['LastUpdateDate']
        @curr_code = params['CurrCode']
        @lease_balance = params['LeaseBalance']
        @is_current = params['IsCurrent']
        @block_e_payments = params['BlockEPayments']
        @guarantor = params['Guarantor']
        @lease_term = params['LeaseTerm']
        @number_of_garages = params['NumberOfGarages']
        @date_notified = params['DateNotified']
        @vacate_reason = params['VacateReason']
        @number_of_units = params['NumberOfUnits']
        @description = params['Description']
        @has_pet = params['HasPet']
        @resident_vacate_date = params['ResidentVacateDate']
        @number_of_occupants = params['NumberOfOccupants']
        @name_group = params['Namegroup']
        @phone_number = params['PhoneNumber']
        @no_checks_in_web_cash_receipts = params['NoChecksInWebCashReceipts']
        @cell_phone_number = params['CellPhoneNumber']
        @scrie_lease = params['SCRIELease']
        @minor = params['Minor']
      end

      # Get the full name of the resident
      #
      # @return [String] the full name
      def full_name
        "#{first_name} #{last_name}".strip
      end

      # Check if the lease is current
      #
      # @return [Boolean] true if the lease is current
      def current?
        is_current == 'Y'
      end

      # Check if the lease is month to month
      #
      # @return [Boolean] true if the lease is month to month
      def month_to_month?
        lease_month_to_month == 'Y'
      end

      # Check if the resident has a pet
      #
      # @return [Boolean] true if the resident has a pet
      def has_pet?
        has_pet == 'Y'
      end

      # Get the lease monthly rent amount as a float
      #
      # @return [Float] the lease monthly rent amount
      def monthly_rent
        lease_monthly_rent_amount.to_f
      end

      # Get the lease balance as a float
      #
      # @return [Float] the lease balance
      def balance
        lease_balance.to_f
      end
    end
  end
end
