# frozen_string_literal: true

module MriHook
  module RequestHandlers
    class OpenChargesHandler < BaseHandler
      API_ENDPOINT = 'MRI_S-PMRM_OpenCharges'

      # Execute the request to get open charges
      #
      # @param [Hash] params the parameters for the request
      # @option params [String] :mri_property_id The MRI property ID (required when last_update is blank)
      # @option params [String] :last_update The last update date
      # @option params [String] :resident_id The resident ID (optional)
      # @return [Array<MriHook::Models::BillingItem>] Array of billing item objects
      def execute(params = {})
        validate_params(params)

        api_params = build_api_params(params)

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
        if params[:last_update]
          # Valid: LastUpdate is provided
          return
        elsif params[:mri_property_id]
          # Valid: RMPROPID is provided
          return
        else
          raise ArgumentError, "Required parameters missing. You must provide one of the following: " \
                              "1) last_update, 2) mri_property_id"
        end
      end

      def build_api_params(params)
        api_params = {}

        # Map Ruby-style parameter names to API parameter names
        api_params['LASTUPDATE'] = params[:last_update] if params[:last_update]
        api_params['RMPROPID'] = params[:mri_property_id] if params[:mri_property_id]
        api_params['ResidentID'] = params[:resident_id] if params[:resident_id]

        api_params
      end

      def parse_response(response)
        return [] unless response['value']

        response['value'].map do |billing_item_data|
          MriHook::Models::BillingItem.new(billing_item_data)
        end
      end
    end
  end
end
