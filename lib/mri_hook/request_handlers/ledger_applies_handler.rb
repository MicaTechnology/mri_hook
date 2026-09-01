# frozen_string_literal: true

module MriHook
  module RequestHandlers
    class LedgerAppliesHandler < BaseHandler
      API_ENDPOINT = 'MRI_S-PMRM_LedgerApplies'
      DATE_FORMAT = /\A\d{4}-\d{2}-\d{2}\z/ # yyyy-mm-dd format

      # Execute the request to get the ledger applies: MRI's own record of how much of each
      # transaction was settled against which other transaction. This is the only place MRI reports
      # a credit being split across several charges -- the resident ledger's ReferenceNumber names
      # just one counterpart and is not the allocation.
      #
      # @param [Hash] params the parameters for the request
      # @option params [String] :resident_name_id The resident name ID
      # @option params [String] :property_id The property ID
      # @option params [String] :start_date Optional start date (format: yyyy-mm-dd)
      # @option params [String] :end_date Optional end date (format: yyyy-mm-dd)
      # @option params [Integer] :top The maximum number of records to return
      # @option params [Integer] :skip The number of records to skip
      # @return [Hash] Hash containing ledger applies and next_link information
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
        # MRI scopes this endpoint by resident and property alone, returning their whole history.
        # The dates are passed through when given, so a caller can narrow the window if MRI honors
        # them, without this handler pretending they are required.
        [:resident_name_id, :property_id].each do |param|
          raise ArgumentError, "#{param} is required" unless params[param]
        end

        validate_date_format(params[:start_date], 'start_date') if params[:start_date]
        validate_date_format(params[:end_date], 'end_date') if params[:end_date]
      end

      def validate_date_format(date, param_name)
        unless date =~ DATE_FORMAT
          raise ArgumentError, "#{param_name} must be in yyyy-mm-dd format"
        end
      end

      def build_api_params(params)
        api_params = {
          'NAMEID' => params[:resident_name_id],
          'PROPERTYID' => params[:property_id]
        }

        api_params['STARTDATE'] = params[:start_date] if params[:start_date]
        api_params['ENDDATE'] = params[:end_date] if params[:end_date]

        # Add pagination parameters if provided
        api_params[:top] = params[:top] if params[:top]
        api_params[:skip] = params[:skip] if params[:skip]
        api_params[:_next] = params[:_next] if params[:_next]

        api_params
      end

      def parse_response(response)
        return { values: [], next_link: nil } unless response['value']

        applies = response['value'].map do |apply_data|
          MriHook::Models::LedgerApply.new(apply_data)
        end

        # Return both the applies and the next_link information
        {
          values: applies,
          next_link: response['next_link']
        }
      end
    end
  end
end
