# frozen_string_literal: true

module MriHook
  module Models
    # One row of MRI's ledger applies table: a statement that `Amount` of one ledger transaction was
    # settled against another. Every row pairs a charge with a credit, but MRI does not label which
    # side is which -- OriginalTransaction is the transaction that triggered the apply and
    # PostedTransaction the one already sitting open, so a charge shows up on either side depending
    # on which was posted first. Resolve the roles by looking both ids up in the ledger and reading
    # their signs; do not assume a fixed direction.
    class LedgerApply
      attr_accessor :resident_id, :property_id, :amount,
                    :original_transaction, :posted_transaction

      # Initialize a new LedgerApply object
      #
      # @param [Hash] params the parameters to initialize the object with
      def initialize(params = {})
        @resident_id = params['ResidentID']
        @property_id = params['PropertyID']
        @amount = params['Amount']
        @original_transaction = params['OriginalTransaction']
        @posted_transaction = params['PostedTransaction']
      end

      # Get the applied amount as a float, signed as the OriginalTransaction
      #
      # @return [Float] the applied amount
      def amount_value
        amount.to_f
      end

      # How much this row settled, without the sign
      #
      # @return [Float] the magnitude of the applied amount
      def applied_amount
        amount_value.abs
      end

      # Both transactions this row links, in no meaningful order
      #
      # @return [Array<String>] the original and posted transaction ids
      def transaction_ids
        [original_transaction, posted_transaction]
      end

      # The other side of the pair
      #
      # @param [String] transaction_id one of the two transactions in this row
      # @return [String, nil] the opposite transaction, or nil when transaction_id is not in this row
      def counterpart_of(transaction_id)
        case transaction_id
        when original_transaction then posted_transaction
        when posted_transaction then original_transaction
        end
      end
    end
  end
end
