# frozen_string_literal: true

require "spec_helper"

RSpec.describe MriHook::RequestHandlers::PendingMoveInsHandler do
  let(:handler) { described_class.new }
  let(:property_id) { "GCCH02" }
  let(:api_endpoint) { "MRI_S-PMRM_PendingMoveIns" }

  let(:response_body) do
    {
      "odata.metadata" => "https://mrix5api.saas.mrisoftware.com/mriapiservices/api.asp?$api=MRI_S-PMRM_PendingMoveIns&$metadata#MRI.mri_s-pmrm_pendingmoveins-container/mri_s-pmrm_pendingmoveins",
      "nextLink" => "https://mrix5api.saas.mrisoftware.com/mriapiservices/api.asp?%24api=MRI_S-PMRM_PendingMoveIns&PropertyID=GCCH02&%24format=xml&%24top=300&%24skip=301",
      "value" => [
        {
          "ResidentID" => "00S0009003",
          "FirstName" => "MICA TESTING",
          "LastName" => "MICA TESTING",
          "PropertyID" => "GCCH02",
          "BuildingID" => "01",
          "UnitID" => "0809",
          "LeaseID" => "2",
          "ResidentStatus" => "New",
          "ScheduledMoveInDate" => "2025-06-18T00:00:00.0000000",
          "Email" => "jlegorreta@granciudad.mx",
          "Phone" => nil,
          "PreviousAddress" => {
            "entry" => {
              "ResidentID" => "00S0009003",
              "Address1" => "Calle Paraiso",
              "Address2" => "Col Centro",
              "Address3" => nil,
              "City" => "Guanajuato",
              "State" => "GT",
              "Zip" => "38900",
              "Country" => "MX",
              "Phone" => nil
            }
          }
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
          { "PropertyID" => property_id }
        )

        handler.execute(property_id: property_id)
      end

      it "returns an array of PendingMoveIn objects" do
        pending_move_ins = handler.execute(property_id: property_id)

        expect(pending_move_ins).to be_an(Array)
        expect(pending_move_ins.size).to eq(1)
        expect(pending_move_ins.first).to be_a(MriHook::Models::PendingMoveIn)
        expect(pending_move_ins.first.resident_id).to eq("00S0009003")
        expect(pending_move_ins.first.first_name).to eq("MICA TESTING")
        expect(pending_move_ins.first.last_name).to eq("MICA TESTING")
        expect(pending_move_ins.first.property_id).to eq("GCCH02")
        expect(pending_move_ins.first.building_id).to eq("01")
        expect(pending_move_ins.first.unit_id).to eq("0809")
        expect(pending_move_ins.first.lease_id).to eq("2")
        expect(pending_move_ins.first.resident_status).to eq("New")
        expect(pending_move_ins.first.scheduled_move_in_date).to eq("2025-06-18T00:00:00.0000000")
        expect(pending_move_ins.first.email).to eq("jlegorreta@granciudad.mx")
        expect(pending_move_ins.first.phone).to be_nil
      end

      it "includes previous address information" do
        pending_move_ins = handler.execute(property_id: property_id)

        expect(pending_move_ins.first.previous_addresses).to be_an(Array)
        expect(pending_move_ins.first.previous_addresses.size).to eq(1)
        expect(pending_move_ins.first.previous_addresses.first).to be_a(MriHook::Models::PreviousAddress)
        expect(pending_move_ins.first.previous_addresses.first.resident_id).to eq("00S0009003")
        expect(pending_move_ins.first.previous_addresses.first.address1).to eq("Calle Paraiso")
        expect(pending_move_ins.first.previous_addresses.first.address2).to eq("Col Centro")
        expect(pending_move_ins.first.previous_addresses.first.city).to eq("Guanajuato")
        expect(pending_move_ins.first.previous_addresses.first.state).to eq("GT")
        expect(pending_move_ins.first.previous_addresses.first.zip).to eq("38900")
        expect(pending_move_ins.first.previous_addresses.first.country).to eq("MX")
      end
    end

    context "with missing property_id" do
      it "raises an ArgumentError" do
        expect { handler.execute }.to raise_error(ArgumentError, "property_id is required")
      end
    end

    context "when the API returns no pending move-ins" do
      before do
        allow(handler.api_client).to receive(:get).and_return({ "value" => [] })
      end

      it "returns an empty array" do
        pending_move_ins = handler.execute(property_id: property_id)

        expect(pending_move_ins).to be_an(Array)
        expect(pending_move_ins).to be_empty
      end
    end

    context "when the API returns no value key" do
      before do
        allow(handler.api_client).to receive(:get).and_return({})
      end

      it "returns an empty array" do
        pending_move_ins = handler.execute(property_id: property_id)

        expect(pending_move_ins).to be_an(Array)
        expect(pending_move_ins).to be_empty
      end
    end
  end
end
