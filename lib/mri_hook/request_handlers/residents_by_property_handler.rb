# frozen_string_literal: true

module MriHook
  module RequestHandlers
    class ResidentsByPropertyHandler < BaseHandler
      API_ENDPOINT = 'MRI_S-PMRM_ResidentsByPropertyID'

      # Execute the request to get residents by property ID
      #
      # @param [Hash] params the parameters for the request
      # @option params [String] :property_id The MRI property ID
      # @option params [Integer] :top The maximum number of records to return (default: 300)
      # @option params [Integer] :skip The number of records to skip (default: nil)
      # @return [Hash] Hash containing residents and next_link information
      def execute(params = {})
        validate_params(params)

        api_params = { 'RMPROPID' => params[:property_id] }

        # Add pagination parameters if provided
        api_params[:top] = params[:top] if params[:top]
        api_params[:skip] = params[:skip] if params[:skip]

        response = api_client.get(
          api_endpoint,
          api_params
        )

        parse_response(response)
      end

      protected

      def api_endpoint
        API_ENDPOINT
      end

      private

      def validate_params(params)
        raise ArgumentError, "property_id is required" unless params[:property_id]
      end

      def parse_response(response)
        return { values: [], next_link: nil } unless response['value']

        residents = response['value'].map do |resident_data|
          MriHook::Models::Resident.new(resident_data)
        end

        # Return both the residents and the next_link information
        {
          values: residents,
          next_link: response['nextLink']
        }
      end
    end
  end
end
