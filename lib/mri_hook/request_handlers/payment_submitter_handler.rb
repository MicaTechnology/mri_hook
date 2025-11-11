# frozen_string_literal: true

module MriHook
  module RequestHandlers
    class PaymentSubmitterHandler < BaseHandler
      API_ENDPOINT = 'MRI_S-PMRM_PaymentDetailsByPropertyID'

      # Execute the request to post payment details
      #
      # @param [Hash] params the parameters for the request
      # @option params [String] :resident_name_id The resident name ID (required)
      # @option params [String] :property_id The property ID (required)
      # @option params [DateTime] :paid_at The payment date (required)
      # @option params [Numeric] :amount The payment amount (required)
      # @option params [String] :check_number The check number (required, max 15 chars)
      # @option params [String] :external_transaction_number The external transaction number (required, max 10 chars)
      # @option params [String] :charge_id The charge ID (required)
      # @option params [String] :external_batch_id The external batch ID (required, max 30 chars)
      # @option params [String] :description The description (required, max 30 chars)
      # @option params [String] :batch_description The batch description (required, max 30 chars)
      # @option params [String] :check_url The check URL (optional)
      # @option params [DateTime] :deposit_date The deposit date (optional, defaults to paid_at)
      # @return [MriHook::Models::Payment] The payment object with response data
      def execute(params = {})
        validate_params(params)

        payment = MriHook::Models::Payment.new(params)
        payload = {
          "value" => [payment.to_api_hash]
        }

        response = api_client.post(
          api_endpoint,
          {},
          payload,
          include_metadata: true
        )

        parse_response(response, payment)
      end

      protected

      def api_endpoint
        API_ENDPOINT
      end

      private

      def validate_params(params)
        required_params = [
          :resident_name_id, :property_id, :paid_at, :amount, :check_number,
          :external_transaction_number, :charge_id, :external_batch_id,
          :description, :batch_description
        ]

        missing_params = required_params.select { |param| params[param].nil? }
        if missing_params.any?
          raise ArgumentError, "Required parameters missing: #{missing_params.join(', ')}"
        end

        validate_length(params[:check_number], 15, 'check_number')
        validate_length(params[:external_transaction_number], 10, 'external_transaction_number')
        validate_length(params[:external_batch_id], 30, 'external_batch_id')
        validate_length(params[:description], 30, 'description')
        validate_length(params[:batch_description], 30, 'batch_description')
      end

      def validate_length(value, max_length, param_name)
        return if value.nil?
        if value.to_s.length > max_length
          raise ArgumentError, "#{param_name} must be at most #{max_length} characters"
        end
      end

      def parse_response(response, payment)
        return response if response['status'] && response['status'] != '200'
        return response unless response['value']

        response_record = response['value'].first

        return { status: 400, error: response_record["Error"]["Message"] } if response_record['Error']

        # Update the payment object with the response data
        response_record.each do |key, value|
          attr_name = camel_case_to_snake_case(key)
          payment.instance_variable_set("@#{attr_name}", value) if payment.respond_to?("#{attr_name}=")
        end

        { status: 200, response: payment }
      end

      def camel_case_to_snake_case(str)
        # Convert CamelCase to snake_case
        str.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
           .gsub(/([a-z\d])([A-Z])/, '\1_\2')
           .downcase
      end
    end
  end
end
