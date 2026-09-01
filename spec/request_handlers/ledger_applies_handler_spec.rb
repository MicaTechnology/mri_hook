# frozen_string_literal: true

require "spec_helper"

RSpec.describe MriHook::RequestHandlers::LedgerAppliesHandler do
  let(:handler) { described_class.new }
  let(:api_endpoint) { "MRI_S-PMRM_LedgerApplies" }
  let(:resident_name_id) { "0000010449" }
  let(:property_id) { "GCCH01" }

  let(:response_body) do
    {
      "odata.metadata" => "https://mrix5api.saas.mrisoftware.com/mriapiservices/api.asp?$api=MRI_S-PMRM_LedgerApplies&$metadata#MRI.mri_s-pmrm_ledgerapplies-container/mri_s-pmrm_ledgerapplies",
      "value" => [
        {
          "ResidentID" => "0000010449",
          "PropertyID" => "GCCH01",
          "Amount" => "-180.15",
          "OriginalTransaction" => "0000788350",
          "PostedTransaction" => "0000755139"
        },
        {
          "ResidentID" => "0000010449",
          "PropertyID" => "GCCH01",
          "Amount" => "-14360.17",
          "OriginalTransaction" => "0000788350",
          "PostedTransaction" => "0000774767"
        }
      ]
    }
  end

  before do
    allow(handler.api_client).to receive(:get).and_return(response_body)
  end

  describe "#execute" do
    context "with valid parameters" do
      it "calls the API with the correct parameters" do
        expect(handler.api_client).to receive(:get).with(
          api_endpoint,
          {
            "NAMEID" => resident_name_id,
            "PROPERTYID" => property_id
          }
        )

        handler.execute(resident_name_id: resident_name_id, property_id: property_id)
      end

      it "returns a hash with applies and next_link information" do
        result = handler.execute(resident_name_id: resident_name_id, property_id: property_id)

        expect(result).to be_a(Hash)
        expect(result).to have_key(:values)
        expect(result).to have_key(:next_link)

        applies = result[:values]
        expect(applies).to be_an(Array)
        expect(applies.size).to eq(2)
        expect(applies.first).to be_a(MriHook::Models::LedgerApply)
        expect(applies.first.resident_id).to eq("0000010449")
        expect(applies.first.property_id).to eq("GCCH01")
        expect(applies.first.original_transaction).to eq("0000788350")
        expect(applies.first.posted_transaction).to eq("0000755139")
        expect(applies.first.applied_amount).to eq(180.15)

        expect(result[:next_link]).to be_nil
      end

      # The reason this endpoint exists: one credit settling several charges is invisible on the
      # resident ledger, whose ReferenceNumber names only one of them.
      it "returns every row of a credit split across several charges" do
        result = handler.execute(resident_name_id: resident_name_id, property_id: property_id)

        applies = result[:values]
        expect(applies.map(&:original_transaction).uniq).to eq(["0000788350"])
        expect(applies.map(&:posted_transaction)).to eq(%w[0000755139 0000774767])
        expect(applies.sum(&:applied_amount)).to eq(14540.32)
      end

      it "passes the optional date range through when given" do
        expect(handler.api_client).to receive(:get).with(
          api_endpoint,
          {
            "NAMEID" => resident_name_id,
            "PROPERTYID" => property_id,
            "STARTDATE" => "2026-03-01",
            "ENDDATE" => "2026-07-31"
          }
        )

        handler.execute(
          resident_name_id: resident_name_id,
          property_id: property_id,
          start_date: "2026-03-01",
          end_date: "2026-07-31"
        )
      end

      it "omits the date range when it is not given" do
        expect(handler.api_client).to receive(:get) do |_endpoint, api_params|
          expect(api_params).not_to have_key("STARTDATE")
          expect(api_params).not_to have_key("ENDDATE")
          response_body
        end

        handler.execute(resident_name_id: resident_name_id, property_id: property_id)
      end

      it "supports pagination parameters" do
        expect(handler.api_client).to receive(:get).with(
          api_endpoint,
          {
            "NAMEID" => resident_name_id,
            "PROPERTYID" => property_id,
            top: 50,
            skip: 100
          }
        )

        handler.execute(
          resident_name_id: resident_name_id,
          property_id: property_id,
          top: 50,
          skip: 100
        )
      end

      it "supports _next pagination parameter" do
        expect(handler.api_client).to receive(:get).with(
          api_endpoint,
          {
            "NAMEID" => resident_name_id,
            "PROPERTYID" => property_id,
            _next: "ae4940b2ae3c4f29"
          }
        )

        handler.execute(
          resident_name_id: resident_name_id,
          property_id: property_id,
          _next: "ae4940b2ae3c4f29"
        )
      end

      it "returns the next_link when the response is paginated" do
        allow(handler.api_client).to receive(:get).and_return(
          response_body.merge("next_link" => { top: "300", skip: "300", _next: "ae4940b2ae3c4f29" })
        )

        result = handler.execute(resident_name_id: resident_name_id, property_id: property_id)

        expect(result[:next_link]).to eq({ top: "300", skip: "300", _next: "ae4940b2ae3c4f29" })
      end
    end

    context "with missing parameters" do
      it "raises an ArgumentError when resident_name_id is missing" do
        expect {
          handler.execute(property_id: property_id)
        }.to raise_error(ArgumentError, "resident_name_id is required")
      end

      it "raises an ArgumentError when property_id is missing" do
        expect {
          handler.execute(resident_name_id: resident_name_id)
        }.to raise_error(ArgumentError, "property_id is required")
      end
    end

    context "with invalid date formats" do
      it "raises an ArgumentError when start_date is in invalid format" do
        expect {
          handler.execute(
            resident_name_id: resident_name_id,
            property_id: property_id,
            start_date: "01/03/2026"
          )
        }.to raise_error(ArgumentError, "start_date must be in yyyy-mm-dd format")
      end

      it "raises an ArgumentError when end_date is in invalid format" do
        expect {
          handler.execute(
            resident_name_id: resident_name_id,
            property_id: property_id,
            end_date: "07/31/2026"
          )
        }.to raise_error(ArgumentError, "end_date must be in yyyy-mm-dd format")
      end
    end

    context "when the API returns no applies" do
      before do
        allow(handler.api_client).to receive(:get).and_return({ "value" => [] })
      end

      it "returns a hash with empty values and nil next_link" do
        result = handler.execute(resident_name_id: resident_name_id, property_id: property_id)

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
        result = handler.execute(resident_name_id: resident_name_id, property_id: property_id)

        expect(result[:values]).to be_an(Array)
        expect(result[:values]).to be_empty
        expect(result[:next_link]).to be_nil
      end
    end

    context "with custom credentials" do
      it "passes credentials to the API client" do
        credentials = { base_domain: "https://custom.mri.com", base_endpoint: "/api.asp", username: "user", password: "pass" }

        expect(MriHook::ApiClient).to receive(:new).with(**credentials).and_call_original

        described_class.new(credentials: credentials)
      end
    end
  end
end
