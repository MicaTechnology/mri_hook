# frozen_string_literal: true

module MriHook
  module RequestHandlers
    class OpenChargesHandler < BaseHandler
      API_ENDPOINT = 'MRI_S-PMRM_OpenCharges'

      # Execute the request to get open charges
      #
      # @param [Hash] params the parameters for the request
      # @option params [String] :property_id The MRI property ID (required when last_update is blank)
      # @option params [String] :last_update The last update date
      # @option params [String] :resident_id The resident ID/NameID (optional)
      # @option params [Integer] :top The maximum number of records to return (default: 300)
      # @option params [Integer] :skip The number of records to skip (default: nil)
      # @return [Hash] Hash containing billing items and next_link information
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
        elsif params[:property_id]
          # Valid: RMPROPID is provided
          return
        else
          raise ArgumentError, "Required parameters missing. You must provide one of the following: " \
                              "1) last_update, 2) property_id"
        end
      end

      def build_api_params(params)
        api_params = {}

        # Map Ruby-style parameter names to API parameter names
        api_params['LASTUPDATE'] = params[:last_update] if params[:last_update]
        api_params['RMPROPID'] = params[:property_id] if params[:property_id]
        api_params['NameID'] = params[:resident_id] if params[:resident_id]

        # Add pagination parameters if provided
        api_params[:top] = params[:top] if params[:top]
        api_params[:skip] = params[:skip] if params[:skip]

        api_params
      end

      def parse_response(response)
        return { values: [], next_link: nil } unless response['value']

        billing_items = response['value'].map do |billing_item_data|
          MriHook::Models::BillingItem.new(billing_item_data)
        end

        # Return both the billing items and the next_link information
        {
          values: billing_items,
          next_link: response['next_link']
        }
      end
    end
  end
end
