# frozen_string_literal: true

require "spec_helper"

RSpec.describe MriHook::RequestHandlers::ResidentsByPropertyHandler do
  let(:handler) { described_class.new }
  let(:property_id) { "GCNS01" }
  let(:api_endpoint) { "MRI_S-PMRM_ResidentsByPropertyID" }
  let(:api_url) { "https://mrix5api.saas.mrisoftware.com/mriapiservices/api.asp?$api=#{api_endpoint}&$format=json&RMPROPID=#{property_id}" }

  let(:response_body) do
    {
      "odata.metadata" => "https://mrix5api.saas.mrisoftware.com/mriapiservices/api.asp?$api=MRI_S-PMRM_ResidentsByPropertyID&$metadata#MRI.mri_s-pmrm_residentsbypropertyid-container/mri_s-pmrm_residentsbypropertyid",
      "nextLink" => "https://mrix5api.saas.mrisoftware.com/mriapiservices/api.asp?%24api=MRI_S-PMRM_ResidentsByPropertyID&%24format=json&RMPROPID=GCNS01&%24top=300&%24skip=301",
      "value" => [
        {
          "ResidentNameID" => "0000000001",
          "RMPROPID" => "GCNS01",
          "RMBLDGID" => "01",
          "UNITID" => "101",
          "RMLEASEID" => "1",
          "ResidentType" => "R",
          "Status" => "O",
          "FirstName" => "S.A. DE C.V.",
          "LastName" => "CJ LOGISTICS MEXICO",
          "PhoneNumber" => nil,
          "Email" => nil,
          "OccupantOccupyDate" => "2018-01-12T00:00:00",
          "LastUpdateDate" => "2020-02-25T00:00:00",
          "Namegroup" => "0000000001",
          "WorkPhone1" => nil,
          "WorkPhone2" => nil,
          "Cell" => nil,
          "VacateDate" => "2020-01-01T00:00:00"
        },
        {
          "ResidentNameID" => "0000000002",
          "RMPROPID" => "GCNS01",
          "RMBLDGID" => "01",
          "UNITID" => "101",
          "RMLEASEID" => "1",
          "ResidentType" => "R",
          "Status" => "R",
          "FirstName" => "KIM",
          "LastName" => "EUN YOUNG",
          "PhoneNumber" => nil,
          "Email" => nil,
          "OccupantOccupyDate" => "2018-01-12T00:00:00",
          "LastUpdateDate" => "2019-05-08T00:00:00",
          "Namegroup" => "0000000001",
          "WorkPhone1" => nil,
          "WorkPhone2" => nil,
          "Cell" => nil,
          "VacateDate" => nil
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
          { "RMPROPID" => property_id }
        )

        handler.execute(property_id: property_id)
      end

      it "returns an array of Resident objects" do
        residents = handler.execute(property_id: property_id)

        expect(residents).to be_an(Array)
        expect(residents.size).to eq(2)
        expect(residents.first).to be_a(MriHook::Models::Resident)
        expect(residents.first.resident_name_id).to eq("0000000001")
        expect(residents.last.resident_name_id).to eq("0000000002")
      end
    end

    context "with missing property_id" do
      it "raises an ArgumentError" do
        expect { handler.execute }.to raise_error(ArgumentError, "property_id is required")
      end
    end

    context "when the API returns no residents" do
      before do
        allow(handler.api_client).to receive(:get).and_return({ "value" => [] })
      end

      it "returns an empty array" do
        residents = handler.execute(property_id: property_id)

        expect(residents).to be_an(Array)
        expect(residents).to be_empty
      end
    end

    context "when the API returns no value key" do
      before do
        allow(handler.api_client).to receive(:get).and_return({})
      end

      it "returns an empty array" do
        residents = handler.execute(property_id: property_id)

        expect(residents).to be_an(Array)
        expect(residents).to be_empty
      end
    end
  end
end
