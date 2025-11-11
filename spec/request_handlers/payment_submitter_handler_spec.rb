# frozen_string_literal: true

require "spec_helper"

RSpec.describe MriHook::RequestHandlers::PaymentSubmitterHandler do
  let(:handler) { described_class.new }
  let(:api_endpoint) { "MRI_S-PMRM_PaymentDetailsByPropertyID" }

  let(:payment_params) do
    {
      resident_name_id: "0000000467",
      property_id: "GCNS01",
      paid_at: DateTime.parse("2024-02-22"),
      amount: 1000.00,
      check_number: "1232",
      external_transaction_number: "0000000002",
      charge_id: "0000325496",
      external_batch_id: "B1",
      description: "Custom Description",
      batch_description: "Custom Description",
      check_url: "http://example.mrisoftware.com/checkImage",
      deposit_date: DateTime.parse("2024-12-12")
    }
  end

  let(:expected_payload) do
    {
      "odata.metadata" => "https://mrix5api.saas.mrisoftware.com/mriapiservices/api.asp?$api=MRI_S-PMRM_PaymentDetailsByPropertyID&$metadata#MRI.mri_s-pmrm_paymentdetailsbypropertyid-container/mri_s-pmrm_paymentdetailsbypropertyid",
      "value" => [
        {
          "ResidentNameID" => "0000000467",
          "PropertyID" => "GCNS01",
          "PaymentInitiationDatetime" => "2024-02-22",
          "PaymentAmount" => "1000.00",
          "PaymentType" => "C",
          "CheckNumber" => "1232",
          "PartnerName" => "MICA",
          "ExternalTransactionNumber" => "0000000002",
          "ChargeID" => "0000325496",
          "ExternalBatchID" => "B1",
          "Description" => "Custom Description",
          "BatchDescription" => "Custom Description",
          "CheckURL" => "http://example.mrisoftware.com/checkImage",
          "DepositDate" => "2024-12-12",
          "CashType" => "VM"
        }
      ]
    }
  end

  let(:response_body) do
    {
      "odata.metadata" => "https://mrix5api.saas.mrisoftware.com/mriapiservices/api.asp?$api=MRI_S-PMRM_PaymentDetailsByPropertyID&$metadata#MRI.mri_s-pmrm_paymentdetailsbypropertyid-container/mri_s-pmrm_paymentdetailsbypropertyid",
      "value" => [
        {
          "TransactionID" => "00000530PP",
          "ResidentNameID" => "0000000467",
          "PropertyID" => "GCNS01",
          "SiteID" => nil,
          "ChargeCode" => "PPR",
          "PaymentInitiationDatetime" => "2024-02-22T00:00:00",
          "PaymentAmount" => "1000.00",
          "CheckNumber" => "1232",
          "PaymentType" => "C",
          "PartnerName" => "MICA",
          "ExternalTransactionNumber" => "0000000002",
          "ExternalBatchID" => "B1",
          "Description" => "Custom Description",
          "BatchDescription" => "Custom Description",
          "CheckURL" => "http://example.mrisoftware.com/checkImage",
          "UpdateControlTotal" => "N",
          "ChargeID" => "0000325496",
          "DepositDate" => "2024-12-12T00:00:00",
          "BatchId" => "00000000019738",
          "ApplyToChargesThroughDate" => nil,
          "TrackingValue" => nil,
          "ApplyToDirectDebitOnly" => "N",
          "CashType" => "VM"
        }
      ]
    }
  end

  before do
    # Mock the API client
    allow(handler.api_client).to receive(:post).and_return(response_body)
  end

  describe "#execute" do
    context "with valid parameters" do
      it "calls the API with the correct parameters" do
        expect(handler.api_client).to receive(:post).with(
          api_endpoint,
          {},
          {
            "value" => [
              {
                "ResidentNameID" => "0000000467",
                "PropertyID" => "GCNS01",
                "PaymentInitiationDatetime" => "2024-02-22",
                "PaymentAmount" => "1000.00",
                "PaymentType" => "C",
                "CheckNumber" => "1232",
                "PartnerName" => "MICA",
                "ExternalTransactionNumber" => "0000000002",
                "ChargeID" => "0000325496",
                "ExternalBatchID" => "B1",
                "Description" => "Custom Description",
                "BatchDescription" => "Custom Description",
                "CheckURL" => "http://example.mrisoftware.com/checkImage",
                "DepositDate" => "2024-12-12",
                "CashType" => "VM"
              }
            ]
          },
          include_metadata: true
        )

        handler.execute(payment_params)
      end

      it "returns a Payment object with response data" do
        response = handler.execute(payment_params)
        payment = response[:response]
        expect(payment).to be_a(MriHook::Models::Payment)
        expect(payment.transaction_id).to eq("00000530PP")
        expect(payment.resident_name_id).to eq("0000000467")
        expect(payment.property_id).to eq("GCNS01")
        expect(payment.charge_code).to eq("PPR")
        expect(payment.batch_id).to eq("00000000019738")
      end
    end

    context "with missing required parameters" do
      it "raises an ArgumentError when resident_name_id is missing" do
        params = payment_params.dup
        params.delete(:resident_name_id)
        expect { handler.execute(params) }.to raise_error(ArgumentError, /Required parameters missing/)
      end

      it "raises an ArgumentError when property_id is missing" do
        params = payment_params.dup
        params.delete(:property_id)
        expect { handler.execute(params) }.to raise_error(ArgumentError, /Required parameters missing/)
      end

      it "raises an ArgumentError when paid_at is missing" do
        params = payment_params.dup
        params.delete(:paid_at)
        expect { handler.execute(params) }.to raise_error(ArgumentError, /Required parameters missing/)
      end

      it "raises an ArgumentError when amount is missing" do
        params = payment_params.dup
        params.delete(:amount)
        expect { handler.execute(params) }.to raise_error(ArgumentError, /Required parameters missing/)
      end

      it "raises an ArgumentError when check_number is missing" do
        params = payment_params.dup
        params.delete(:check_number)
        expect { handler.execute(params) }.to raise_error(ArgumentError, /Required parameters missing/)
      end

      it "raises an ArgumentError when external_transaction_number is missing" do
        params = payment_params.dup
        params.delete(:external_transaction_number)
        expect { handler.execute(params) }.to raise_error(ArgumentError, /Required parameters missing/)
      end

      it "raises an ArgumentError when charge_id is missing" do
        params = payment_params.dup
        params.delete(:charge_id)
        expect { handler.execute(params) }.to raise_error(ArgumentError, /Required parameters missing/)
      end

      it "raises an ArgumentError when external_batch_id is missing" do
        params = payment_params.dup
        params.delete(:external_batch_id)
        expect { handler.execute(params) }.to raise_error(ArgumentError, /Required parameters missing/)
      end

      it "raises an ArgumentError when description is missing" do
        params = payment_params.dup
        params.delete(:description)
        expect { handler.execute(params) }.to raise_error(ArgumentError, /Required parameters missing/)
      end

      it "raises an ArgumentError when batch_description is missing" do
        params = payment_params.dup
        params.delete(:batch_description)
        expect { handler.execute(params) }.to raise_error(ArgumentError, /Required parameters missing/)
      end
    end

    context "with parameters exceeding maximum length" do
      it "raises an ArgumentError when check_number exceeds maximum length" do
        params = payment_params.dup
        params[:check_number] = "1" * 16
        expect { handler.execute(params) }.to raise_error(ArgumentError, /check_number must be at most 15 characters/)
      end

      it "raises an ArgumentError when external_transaction_number exceeds maximum length" do
        params = payment_params.dup
        params[:external_transaction_number] = "2" * 11
        expect { handler.execute(params) }.to raise_error(ArgumentError, /external_transaction_number must be at most 10 characters/)
      end

      it "raises an ArgumentError when external_batch_id exceeds maximum length" do
        params = payment_params.dup
        params[:external_batch_id] = "3" * 31
        expect { handler.execute(params) }.to raise_error(ArgumentError, /external_batch_id must be at most 30 characters/)
      end

      it "raises an ArgumentError when description exceeds maximum length" do
        params = payment_params.dup
        params[:description] = "4" * 31
        expect { handler.execute(params) }.to raise_error(ArgumentError, /description must be at most 30 characters/)
      end

      it "raises an ArgumentError when batch_description exceeds maximum length" do
        params = payment_params.dup
        params[:batch_description] = "5" * 31
        expect { handler.execute(params) }.to raise_error(ArgumentError, /batch_description must be at most 30 characters/)
      end
    end

    context "when the API returns no value key" do
      before do
        allow(handler.api_client).to receive(:post).and_return({})
      end

      it "returns a Payment object without response data" do
        payment = handler.execute(payment_params)

        expect(payment).to be_a(Hash)
        expect(payment).to be_empty
      end
    end
  end
end
