# frozen_string_literal: true

module MriHook
  module RequestHandlers
    class ResidentLedgerHandler < BaseHandler
      API_ENDPOINT = 'MRI_S-PMRM_ResidentLedger'
      DATE_FORMAT = /\A\d{4}-\d{2}-\d{2}\z/ # yyyy-mm-dd format

      # Execute the request to get resident ledger transactions
      #
      # @param [Hash] params the parameters for the request
      # @option params [String] :start_date The start date (format: yyyy-mm-dd)
      # @option params [String] :end_date The end date (format: yyyy-mm-dd)
      # @option params [String] :resident_name_id The resident name ID
      # @option params [String] :property_id The property ID
      # @return [Array<MriHook::Models::LedgerTransaction>] Array of ledger transaction objects
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
        # Check that all required parameters are provided
        [:start_date, :end_date, :resident_name_id, :property_id].each do |param|
          raise ArgumentError, "#{param} is required" unless params[param]
        end

        # Validate date formats
        validate_date_format(params[:start_date], 'start_date')
        validate_date_format(params[:end_date], 'end_date')
      end

      def validate_date_format(date, param_name)
        unless date =~ DATE_FORMAT
          raise ArgumentError, "#{param_name} must be in yyyy-mm-dd format"
        end
      end

      def build_api_params(params)
        {
          'STARTDATE' => params[:start_date],
          'ENDDATE' => params[:end_date],
          'NAMEID' => params[:resident_name_id],
          'PROPERTYID' => params[:property_id]
        }
      end

      def parse_response(response)
        return [] unless response['value']

        response['value'].map do |transaction_data|
          MriHook::Models::LedgerTransaction.new(transaction_data)
        end
      end
    end
  end
end
