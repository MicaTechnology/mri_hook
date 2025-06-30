# frozen_string_literal: true

module MriHook
  module RequestHandlers
    class PendingMoveInsHandler < BaseHandler
      API_ENDPOINT = 'MRI_S-PMRM_PendingMoveIns'

      # Execute the request to get pending move-ins
      #
      # @param [Hash] params the parameters for the request
      # @option params [String] :property_id The property ID (required)
      # @return [Array<MriHook::Models::PendingMoveIn>] Array of pending move-in objects
      def execute(params = {})
        validate_params(params)

        response = api_client.get(
          api_endpoint,
          { 'PropertyID' => params[:property_id] }
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
        return [] unless response['value']

        response['value'].map do |pending_move_in_data|
          MriHook::Models::PendingMoveIn.new(pending_move_in_data)
        end
      end
    end
  end
end
