# frozen_string_literal: true

module MriHook
  module RequestHandlers
    class CreditBalanceSubmitterHandler < PaymentSubmitterHandler
      private

      def validate_params(params)
        required_params = [
          :resident_name_id, :property_id, :paid_at, :amount, :check_number,
          :external_transaction_number, :external_batch_id,
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
    end
  end
end
