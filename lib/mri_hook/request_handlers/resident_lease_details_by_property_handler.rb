# frozen_string_literal: true

module MriHook
  module RequestHandlers
    class ResidentLeaseDetailsByPropertyHandler < BaseHandler
      API_ENDPOINT = 'MRI_S-PMRM_ResidentLeaseDetailsByPropertyID'

      # Execute the request to get resident lease details
      #
      # @param [Hash] params the parameters for the request
      # @option params [String] :property_id The MRI property ID
      # @option params [String] :last_update_date The last update date
      # @option params [String] :start_date The start date
      # @option params [String] :end_date The end date (required if start_date is provided)
      # @option params [Integer] :top The maximum number of records to return (default: 300)
      # @option params [Integer] :skip The number of records to skip (default: nil)
      # @return [Hash] Hash containing leases and next_link information
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
        if params[:property_id]
          # Valid: RmPropID is provided
          return
        elsif params[:last_update_date]
          # Valid: LastUpdateDate is provided
          return
        elsif params[:start_date]
          # Valid: StartDate is provided, but EndDate is also required
          raise ArgumentError, "end_date is required when start_date is provided" unless params[:end_date]
          return
        else
          raise ArgumentError, "Required parameters missing. You must provide one of the following: " \
                              "1) property_id, 2) last_update_date, 3) start_date and end_date"
        end
      end

      def build_api_params(params)
        api_params = {}

        # Map Ruby-style parameter names to API parameter names
        api_params['RMPROPID'] = params[:property_id] if params[:property_id]
        api_params['LastUpdateDate'] = params[:last_update_date] if params[:last_update_date]
        api_params['StartDate'] = params[:start_date] if params[:start_date]
        api_params['EndDate'] = params[:end_date] if params[:end_date]

        # Add pagination parameters if provided
        api_params[:top] = params[:top] if params[:top]
        api_params[:skip] = params[:skip] if params[:skip]

        api_params
      end

      def parse_response(response)
        return { values: [], next_link: nil } unless response['value']

        leases = response['value'].map do |lease_data|
          MriHook::Models::Lease.new(lease_data)
        end

        # Return both the leases and the next_link information
        {
          values: leases,
          next_link: response['nextLink']
        }
      end
    end
  end
end
