# frozen_string_literal: true

require "spec_helper"

RSpec.describe MriHook::RequestHandlers::ResidentLedgerHandler do
  let(:handler) { described_class.new }
  let(:api_endpoint) { "MRI_S-PMRM_ResidentLedger" }
  let(:start_date) { "2024-01-01" }
  let(:end_date) { "2025-06-30" }
  let(:resident_name_id) { "0000009006" }
  let(:property_id) { "GCCH01" }

  let(:response_body) do
    {
      "odata.metadata" => "https://mrix5api.saas.mrisoftware.com/mriapiservices/api.asp?$api=MRI_S-PMRM_ResidentLedger&$metadata#MRI.mri_s-pmrm_residentledger-container/mri_s-pmrm_residentledger",
      "value" => [
        {
          "TransactionID" => "00000526PP",
          "PropertyID" => "GCCH01",
          "NameID" => "0000009006",
          "TransactionDate" => "2024-02-22T00:00:00",
          "ChargeCode" => "RNI",
          "SourceCode" => "CR",
          "CashType" => "VM",
          "Description" => "Custom Description",
          "TransactionAmount" => "-1000.00",
          "OpenAmount" => "0.00",
          "ReceiptDescriptor" => "1232_3",
          "ReferenceNumber" => "0000496133",
          "Posted" => "Y",
          "NameGroup" => "0000009006"
        }
      ]
    }
  end

  before do
    # Mock the API client
    allow(handler.api_client).to receive(:get).and_return(response_body)
  end

  describe "#execute" do
    context "with valid parameters" do
      it "calls the API with the correct parameters" do
        expect(handler.api_client).to receive(:get).with(
          api_endpoint,
          {
            "STARTDATE" => start_date,
            "ENDDATE" => end_date,
            "NAMEID" => resident_name_id,
            "PROPERTYID" => property_id
          }
        )

        handler.execute(
          start_date: start_date,
          end_date: end_date,
          resident_name_id: resident_name_id,
          property_id: property_id
        )
      end

      it "returns a hash with transactions and next_link information" do
        result = handler.execute(
          start_date: start_date,
          end_date: end_date,
          resident_name_id: resident_name_id,
          property_id: property_id
        )

        expect(result).to be_a(Hash)
        expect(result).to have_key(:values)
        expect(result).to have_key(:next_link)

        transactions = result[:values]
        expect(transactions).to be_an(Array)
        expect(transactions.size).to eq(1)
        expect(transactions.first).to be_a(MriHook::Models::LedgerTransaction)
        expect(transactions.first.transaction_id).to eq("00000526PP")
        expect(transactions.first.property_id).to eq("GCCH01")
        expect(transactions.first.resident_name_id).to eq("0000009006")
        expect(transactions.first.transaction_date).to eq("2024-02-22T00:00:00")
        expect(transactions.first.transaction_amount).to eq("-1000.00")
        expect(transactions.first.payment?).to be true
        expect(transactions.first.charge?).to be false

        expect(result[:next_link]).to be_nil
      end

      it "supports pagination parameters" do
        expect(handler.api_client).to receive(:get).with(
          api_endpoint,
          {
            "STARTDATE" => start_date,
            "ENDDATE" => end_date,
            "NAMEID" => resident_name_id,
            "PROPERTYID" => property_id,
            top: 50,
            skip: 100
          }
        )

        handler.execute(
          start_date: start_date,
          end_date: end_date,
          resident_name_id: resident_name_id,
          property_id: property_id,
          top: 50,
          skip: 100
        )
      end
    end

    context "with missing parameters" do
      it "raises an ArgumentError when start_date is missing" do
        expect {
          handler.execute(
            end_date: end_date,
            resident_name_id: resident_name_id,
            property_id: property_id
          )
        }.to raise_error(ArgumentError, "start_date is required")
      end

      it "raises an ArgumentError when end_date is missing" do
        expect {
          handler.execute(
            start_date: start_date,
            resident_name_id: resident_name_id,
            property_id: property_id
          )
        }.to raise_error(ArgumentError, "end_date is required")
      end

      it "raises an ArgumentError when resident_name_id is missing" do
        expect {
          handler.execute(
            start_date: start_date,
            end_date: end_date,
            property_id: property_id
          )
        }.to raise_error(ArgumentError, "resident_name_id is required")
      end

      it "raises an ArgumentError when property_id is missing" do
        expect {
          handler.execute(
            start_date: start_date,
            end_date: end_date,
            resident_name_id: resident_name_id
          )
        }.to raise_error(ArgumentError, "property_id is required")
      end
    end

    context "with invalid date formats" do
      it "raises an ArgumentError when start_date is in invalid format" do
        expect {
          handler.execute(
            start_date: "01/01/2024",
            end_date: end_date,
            resident_name_id: resident_name_id,
            property_id: property_id
          )
        }.to raise_error(ArgumentError, "start_date must be in yyyy-mm-dd format")
      end

      it "raises an ArgumentError when end_date is in invalid format" do
        expect {
          handler.execute(
            start_date: start_date,
            end_date: "06/30/2025",
            resident_name_id: resident_name_id,
            property_id: property_id
          )
        }.to raise_error(ArgumentError, "end_date must be in yyyy-mm-dd format")
      end
    end

    context "when the API returns no transactions" do
      before do
        allow(handler.api_client).to receive(:get).and_return({ "value" => [] })
      end

      it "returns a hash with empty values and nil next_link" do
        result = handler.execute(
          start_date: start_date,
          end_date: end_date,
          resident_name_id: resident_name_id,
          property_id: property_id
        )

        expect(result).to be_a(Hash)
        expect(result).to have_key(:values)
        expect(result).to have_key(:next_link)

        expect(result[:values]).to be_an(Array)
        expect(result[:values]).to be_empty
        expect(result[:next_link]).to be_nil
      end
    end

    context "when the API returns no value key" do
      before do
        allow(handler.api_client).to receive(:get).and_return({})
      end

      it "returns a hash with empty values and nil next_link" do
        result = handler.execute(
          start_date: start_date,
          end_date: end_date,
          resident_name_id: resident_name_id,
          property_id: property_id
        )

        expect(result).to be_a(Hash)
        expect(result).to have_key(:values)
        expect(result).to have_key(:next_link)

        expect(result[:values]).to be_an(Array)
        expect(result[:values]).to be_empty
        expect(result[:next_link]).to be_nil
      end
    end
  end
end
