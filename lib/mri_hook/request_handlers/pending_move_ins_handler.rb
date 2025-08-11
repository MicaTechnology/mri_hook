# frozen_string_literal: true

module MriHook
  module RequestHandlers
    class PendingMoveInsHandler < BaseHandler
      API_ENDPOINT = 'MRI_S-PMRM_PendingMoveIns'

      # Execute the request to get pending move-ins
      #
      # @param [Hash] params the parameters for the request
      # @option params [String] :property_id The property ID (required)
      # @option params [Integer] :top The maximum number of records to return (default: 300)
      # @option params [Integer] :skip The number of records to skip (default: nil)
      # @return [Hash] Hash containing pending move-ins and next_link information
      def execute(params = {})
        validate_params(params)

        api_params = { 'PropertyID' => params[:property_id] }

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

        pending_move_ins = response['value'].map do |pending_move_in_data|
          MriHook::Models::PendingMoveIn.new(pending_move_in_data)
        end

        # Return both the pending move-ins and the next_link information
        {
          values: pending_move_ins,
          next_link: response['nextLink']
        }
      end
    end
  end
end
