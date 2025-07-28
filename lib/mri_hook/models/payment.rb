# frozen_string_literal: true

module MriHook
  module Models
    class Payment
      PARTNER_NAME = 'MICA'
      CASH_TYPE = 'V2'
      PAYMENT_TYPE = 'C'

      attr_accessor :resident_name_id, :property_id, :paid_at, :amount, :check_number,
                    :external_transaction_number, :charge_id, :external_batch_id,
                    :description, :batch_description, :check_url, :deposit_date,
                    :transaction_id, :site_id, :charge_code, :partner_name, :payment_type,
                    :update_control_total, :batch_id, :apply_to_charges_through_date,
                    :tracking_value, :apply_to_direct_debit_only, :cash_type

      # Initialize a new Payment object
      #
      # @param [Hash] params the parameters to initialize the object with
      def initialize(params = {})
        # Request parameters
        @resident_name_id = params[:resident_name_id]
        @property_id = params[:property_id]
        @paid_at = params[:paid_at]
        @amount = params[:amount]
        @check_number = params[:check_number]
        @external_transaction_number = params[:external_transaction_number]
        @charge_id = params[:charge_id]
        @external_batch_id = params[:external_batch_id]
        @description = params[:description]
        @batch_description = params[:batch_description]
        @check_url = params[:check_url]
        @deposit_date = params[:deposit_date] || @paid_at

        # Response parameters
        @transaction_id = params['TransactionID']
        @site_id = params['SiteID']
        @charge_code = params['ChargeCode']
        @partner_name = params['PartnerName']
        @payment_type = params['PaymentType']
        @update_control_total = params['UpdateControlTotal']
        @batch_id = params['BatchId']
        @apply_to_charges_through_date = params['ApplyToChargesThroughDate']
        @tracking_value = params['TrackingValue']
        @apply_to_direct_debit_only = params['ApplyToDirectDebitOnly']
        @cash_type = params['CashType']
      end

      # Convert the payment to a hash for the API request
      #
      # @return [Hash] the payment as a hash for the API request
      def to_api_hash
        {
          "ResidentNameID" => @resident_name_id,
          "PropertyID" => @property_id,
          "PaymentInitiationDatetime" => format_date(@paid_at),
          "PaymentAmount" => format_amount(@amount),
          "PaymentType" => PAYMENT_TYPE,
          "CheckNumber" => @check_number.to_s[0, 15], # MAX 15 chars
          "PartnerName" => PARTNER_NAME,
          "ExternalTransactionNumber" => @external_transaction_number.to_s[0, 10], # MAX 10 chars
          "ChargeID" => @charge_id,
          "ExternalBatchID" => @external_batch_id.to_s[0, 30], # MAX 30 chars
          "Description" => @description.to_s[0, 30], # MAX 30 chars
          "BatchDescription" => @batch_description.to_s[0, 30], # MAX 30 chars
          "CheckURL" => @check_url,
          "DepositDate" => format_date(@deposit_date),
          "CashType" => CASH_TYPE,
        }
      end

      private

      # Format a date for the API request
      #
      # @param [DateTime] date the date to format
      # @return [String] the formatted date
      def format_date(date)
        return nil unless date
        date.strftime('%Y-%m-%d')
      end

      # Format an amount for the API request
      #
      # @param [Numeric] amount the amount to format
      # @return [String] the formatted amount
      def format_amount(amount)
        return nil unless amount
        sprintf('%.2f', amount)
      end
    end
  end
end
