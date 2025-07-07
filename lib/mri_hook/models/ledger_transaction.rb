# frozen_string_literal: true

module MriHook
  module Models
    class LedgerTransaction
      attr_accessor :transaction_id, :property_id, :resident_name_id, :transaction_date,
                    :charge_code, :source_code, :cash_type, :description,
                    :transaction_amount, :open_amount, :receipt_descriptor,
                    :reference_number, :posted, :name_group

      # Initialize a new LedgerTransaction object
      #
      # @param [Hash] params the parameters to initialize the object with
      def initialize(params = {})
        @transaction_id = params['TransactionID']
        @property_id = params['PropertyID']
        @resident_name_id = params['NameID']
        @transaction_date = params['TransactionDate']
        @charge_code = params['ChargeCode']
        @source_code = params['SourceCode']
        @cash_type = params['CashType']
        @description = params['Description']
        @transaction_amount = params['TransactionAmount']
        @open_amount = params['OpenAmount']
        @receipt_descriptor = params['ReceiptDescriptor']
        @reference_number = params['ReferenceNumber']
        @posted = params['Posted']
        @name_group = params['NameGroup']
      end

      # Check if the transaction is posted
      #
      # @return [Boolean] true if the transaction is posted
      def posted?
        posted == 'Y'
      end

      # Get the transaction amount as a float
      #
      # @return [Float] the transaction amount
      def transaction_amount_value
        transaction_amount.to_f
      end

      # Get the open amount as a float
      #
      # @return [Float] the open amount
      def open_amount_value
        open_amount.to_f
      end

      # Check if the transaction is a payment
      #
      # @return [Boolean] true if the transaction is a payment
      def payment?
        transaction_amount_value < 0
      end

      # Check if the transaction is a charge
      #
      # @return [Boolean] true if the transaction is a charge
      def charge?
        transaction_amount_value > 0
      end
    end
  end
end
