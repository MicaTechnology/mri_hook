# frozen_string_literal: true

module MriHook
  module RequestHandlers
    class ResidentsHandler < BaseHandler
      API_ENDPOINT = 'MRI_S-PMRM_Residents'

      # Execute the request to get residents
      #
      # @param [Hash] params the parameters for the request
      # @option params [String] :last_update The last update date (format: MM-DD-YYYY)
      # @option params [String] :name_id The resident name ID
      # @option params [String] :start_date The start date (format: MM-DD-YYYY)
      # @option params [String] :end_date The end date (format: MM-DD-YYYY)
      # @option params [String] :property_id The property ID
      # @option params [String] :type The resident type
      # @option params [String] :status The resident status
      # @option params [Boolean] :include_pii Whether to include PII (defaults to true)
      # @return [Array<MriHook::Models::Resident>] Array of resident objects
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
        elsif params[:name_id]
          # Valid: NameID is provided
          return
        elsif params[:start_date] && params[:end_date]
          # Valid: StartDate and EndDate are provided
          return
        elsif params[:property_id] && params[:type] && params[:status]
          # Valid: PropertyID, Type, and Status are all provided
          return
        else
          raise ArgumentError, "Required parameters missing. You must provide one of the following combinations: " \
                              "1) last_update, 2) name_id, 3) start_date and end_date, " \
                              "4) property_id, type, and status"
        end
      end

      def build_api_params(params)
        api_params = {}

        # Map Ruby-style parameter names to API parameter names
        api_params['LastUpdate'] = params[:last_update] if params[:last_update]
        api_params['NameID'] = params[:name_id] if params[:name_id]
        api_params['StartDate'] = params[:start_date] if params[:start_date]
        api_params['EndDate'] = params[:end_date] if params[:end_date]
        api_params['PropertyID'] = params[:property_id] if params[:property_id]
        api_params['Type'] = params[:type] if params[:type]
        api_params['Status'] = params[:status] if params[:status]

        # Include PII by default unless explicitly set to false
        include_pii = params.key?(:include_pii) ? params[:include_pii] : true
        api_params['IncludePII'] = include_pii ? 'Y' : 'N'

        api_params
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
