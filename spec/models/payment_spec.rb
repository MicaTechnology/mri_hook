# frozen_string_literal: true

require "spec_helper"

RSpec.describe MriHook::Models::Payment do
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

  let(:response_data) do
    {
      "TransactionID" => "00000530PP",
      "ResidentNameID" => "0000000467",
      "PropertyID" => "GCNS01",
      "SiteID" => nil,
      "ChargeCode" => "PPR",
      "PaymentInitiationDatetime" => "2024-02-22T00:00:00",
      "PaymentAmount" => "1200.00",
      "CheckNumber" => "88888888",
      "PaymentType" => "C",
      "PartnerName" => "MICA",
      "ExternalTransactionNumber" => "88888889",
      "ExternalBatchID" => "88888889",
      "Description" => "Custom Description",
      "BatchDescription" => "Custom Description",
      "CheckURL" => "http://example.mrisoftware.com/checkImage",
      "UpdateControlTotal" => "N",
      "ChargeID" => "0000325400",
      "DepositDate" => "2024-12-12T00:00:00",
      "BatchId" => "00000000019738",
      "ApplyToChargesThroughDate" => nil,
      "TrackingValue" => nil,
      "ApplyToDirectDebitOnly" => "N",
      "CashType" => "V2"
    }
  end

  subject { described_class.new(payment_params) }

  describe "#initialize" do
    it "sets attributes from the params" do
      expect(subject.resident_name_id).to eq("0000000467")
      expect(subject.property_id).to eq("GCNS01")
      expect(subject.paid_at).to eq(DateTime.parse("2024-02-22"))
      expect(subject.amount).to eq(1000.00)
      expect(subject.check_number).to eq("1232")
      expect(subject.external_transaction_number).to eq("0000000002")
      expect(subject.charge_id).to eq("0000325496")
      expect(subject.external_batch_id).to eq("B1")
      expect(subject.description).to eq("Custom Description")
      expect(subject.batch_description).to eq("Custom Description")
      expect(subject.check_url).to eq("http://example.mrisoftware.com/checkImage")
      expect(subject.deposit_date).to eq(DateTime.parse("2024-12-12"))
    end

    it "sets deposit_date to paid_at if not provided" do
      params = payment_params.dup
      params.delete(:deposit_date)
      payment = described_class.new(params)
      expect(payment.deposit_date).to eq(payment.paid_at)
    end

    it "sets response attributes when initialized with response data" do
      payment = described_class.new(response_data)
      expect(payment.transaction_id).to eq("00000530PP")
      expect(payment.site_id).to be_nil
      expect(payment.charge_code).to eq("PPR")
      expect(payment.partner_name).to eq("MICA")
      expect(payment.payment_type).to eq("C")
      expect(payment.update_control_total).to eq("N")
      expect(payment.batch_id).to eq("00000000019738")
      expect(payment.apply_to_charges_through_date).to be_nil
      expect(payment.tracking_value).to be_nil
      expect(payment.apply_to_direct_debit_only).to eq("N")
      expect(payment.cash_type).to eq("V2")
    end
  end

  describe "#to_api_hash" do
    it "returns a hash with the correct keys and values" do
      api_hash = subject.to_api_hash
      expect(api_hash["ResidentNameID"]).to eq("0000000467")
      expect(api_hash["PropertyID"]).to eq("GCNS01")
      expect(api_hash["PaymentInitiationDatetime"]).to eq("2024-02-22")
      expect(api_hash["PaymentAmount"]).to eq("1000.00")
      expect(api_hash["PaymentType"]).to eq("C")
      expect(api_hash["CheckNumber"]).to eq("1232")
      expect(api_hash["PartnerName"]).to eq("MICA")
      expect(api_hash["ExternalTransactionNumber"]).to eq("0000000002")
      expect(api_hash["ChargeID"]).to eq("0000325496")
      expect(api_hash["ExternalBatchID"]).to eq("B1")
      expect(api_hash["Description"]).to eq("Custom Description")
      expect(api_hash["BatchDescription"]).to eq("Custom Description")
      expect(api_hash["CheckURL"]).to eq("http://example.mrisoftware.com/checkImage")
      expect(api_hash["DepositDate"]).to eq("2024-12-12")
      expect(api_hash["CashType"]).to eq("V2")
    end

    it "truncates fields that exceed the maximum length" do
      params = payment_params.dup
      params[:check_number] = "1" * 20
      params[:external_transaction_number] = "2" * 20
      params[:external_batch_id] = "3" * 40
      params[:description] = "4" * 40
      params[:batch_description] = "5" * 40
      payment = described_class.new(params)
      api_hash = payment.to_api_hash

      expect(api_hash["CheckNumber"].length).to eq(15)
      expect(api_hash["ExternalTransactionNumber"].length).to eq(10)
      expect(api_hash["ExternalBatchID"].length).to eq(30)
      expect(api_hash["Description"].length).to eq(30)
      expect(api_hash["BatchDescription"].length).to eq(30)
    end

    it "formats dates correctly" do
      api_hash = subject.to_api_hash
      expect(api_hash["PaymentInitiationDatetime"]).to eq("2024-02-22")
      expect(api_hash["DepositDate"]).to eq("2024-12-12")
    end

    it "formats amounts correctly" do
      api_hash = subject.to_api_hash
      expect(api_hash["PaymentAmount"]).to eq("1000.00")
    end
  end
end
