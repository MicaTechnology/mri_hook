# frozen_string_literal: true
require 'debug'

module MriHook
  module Models
    class PreviousAddress
      attr_accessor :resident_name_id, :address1, :address2, :address3, :city, :state, :zip, :country, :phone

      # Initialize a new PreviousAddress object
      #
      # @param [Hash] params the parameters to initialize the object with
      def initialize(params = {})
        @resident_name_id = params['ResidentID']
        @address1 = params['Address1']
        @address2 = params['Address2']
        @address3 = params['Address3']
        @city = params['City']
        @state = params['State']
        @zip = params['Zip']
        @country = params['Country']
        @phone = params['Phone']
      end

      # Get the full address as a string
      #
      # @return [String] the full address
      def full_address
        [address1, address2, address3, city, state, zip, country].compact.reject(&:empty?).compact.join(', ')
      end
    end
  end
end
