# frozen_string_literal: true

module MriHook
  module RequestHandlers
    class ResidentsByPropertyHandler < BaseHandler
      API_ENDPOINT = 'MRI_S-PMRM_ResidentsByPropertyID'

      # Execute the request to get residents by property ID
      #
      # @param [Hash] params the parameters for the request
      # @option params [String] :mri_property_id The MRI property ID
      # @return [Array<MriHook::Models::Resident>] Array of resident objects
      def execute(params = {})
        validate_params(params)

        response = api_client.get(
          api_endpoint,
          { 'RMPROPID' => params[:mri_property_id] }
        )

        parse_response(response)
      end

      protected

      def api_endpoint
        API_ENDPOINT
      end

      private

      def validate_params(params)
        raise ArgumentError, "mri_property_id is required" unless params[:mri_property_id]
      end

      def parse_response(response)
        return [] unless response['value']

        response['value'].map do |resident_data|
          MriHook::Models::Resident.new(resident_data)
        end
      end
    end
  end
end
