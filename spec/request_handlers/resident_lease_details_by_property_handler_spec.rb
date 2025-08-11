# frozen_string_literal: true

require "spec_helper"

RSpec.describe MriHook::RequestHandlers::ResidentLeaseDetailsByPropertyHandler do
  let(:handler) { described_class.new }
  let(:property_id) { "GCNS01" }
  let(:last_update_date) { "2020-02-25" }
  let(:start_date) { "2019-05-01" }
  let(:end_date) { "2020-04-30" }
  let(:api_endpoint) { "MRI_S-PMRM_ResidentLeaseDetailsByPropertyID" }

  let(:response_body) do
    {
      "odata.metadata" => "https://mrix5api.saas.mrisoftware.com/mriapiservices/api.asp?$api=MRI_S-PMRM_ResidentLeaseDetailsByPropertyID&$metadata#MRI.mri_s-pmrm_residentleasedetailsbypropertyid-container/mri_s-pmrm_residentleasedetailsbypropertyid",
      "nextLink" => "https://mrix5api.saas.mrisoftware.com/mriapiservices/api.asp?%24api=MRI_S-PMRM_ResidentLeaseDetailsByPropertyID&RMPROPID=GCNS01&%24format=json&%24top=300&%24skip=301",
      "value" => [
        {
          "ResidentNameID" => "0000000001",
          "PropertyID" => "GCNS01",
          "BuildingID" => "01",
          "UnitID" => "101",
          "LeaseID" => "1",
          "Address" => "Av. Revolución 2703",
          "BuildingAddress" => nil,
          "City" => nil,
          "State" => nil,
          "Zipcode" => nil,
          "FirstName" => "S.A. DE C.V.",
          "LastName" => "CJ LOGISTICS MEXICO",
          "ResidentStatus" => "Old",
          "Email" => nil,
          "Birthday" => nil,
          "LeaseStart" => "2019-05-01T00:00:00",
          "OccupyDate" => "2018-01-12T00:00:00",
          "LeaseEnd" => "2020-04-30T00:00:00",
          "LeaseMonthlyRentAmount" => "38300.00",
          "LeaseMoveOut" => "2020-01-01T00:00:00",
          "LeaseMonthToMonth" => "N",
          "PayAllowed" => nil,
          "LastUpdateDate" => "2020-02-25T19:46:00",
          "CurrCode" => "MXN",
          "LeaseBalance" => "0.00",
          "IsCurrent" => "N",
          "BlockEPayments" => "N",
          "Guarantor" => "N",
          "LeaseTerm" => "12",
          "NumberOfGarages" => nil,
          "DateNotified" => "2020-01-01T00:00:00",
          "VacateReason" => "TR",
          "NumberOfUnits" => "200",
          "Description" => "Main Building",
          "HasPet" => "N",
          "ResidentVacateDate" => "2020-01-01T00:00:00",
          "NumberOfOccupants" => nil,
          "Namegroup" => "0000000001",
          "PhoneNumber" => nil,
          "NoChecksInWebCashReceipts" => "N",
          "CellPhoneNumber" => nil,
          "SCRIELease" => nil,
          "Minor" => "False"
        },
        {
          "ResidentNameID" => "0000000002",
          "PropertyID" => "GCNS01",
          "BuildingID" => "01",
          "UnitID" => "101",
          "LeaseID" => "1",
          "Address" => "Av. Revolución 2703",
          "BuildingAddress" => nil,
          "City" => nil,
          "State" => nil,
          "Zipcode" => nil,
          "FirstName" => "KIM",
          "LastName" => "EUN YOUNG",
          "ResidentStatus" => "Other Resident",
          "Email" => nil,
          "Birthday" => nil,
          "LeaseStart" => "2019-05-01T00:00:00",
          "OccupyDate" => "2018-01-12T00:00:00",
          "LeaseEnd" => "2020-04-30T00:00:00",
          "LeaseMonthlyRentAmount" => "38300.00",
          "LeaseMoveOut" => "2020-01-01T00:00:00",
          "LeaseMonthToMonth" => "N",
          "PayAllowed" => nil,
          "LastUpdateDate" => "2020-02-25T19:46:00",
          "CurrCode" => "MXN",
          "LeaseBalance" => "0.00",
          "IsCurrent" => "N",
          "BlockEPayments" => "N",
          "Guarantor" => "N",
          "LeaseTerm" => "12",
          "NumberOfGarages" => nil,
          "DateNotified" => "2020-01-01T00:00:00",
          "VacateReason" => "TR",
          "NumberOfUnits" => "200",
          "Description" => "Main Building",
          "HasPet" => "N",
          "ResidentVacateDate" => nil,
          "NumberOfOccupants" => nil,
          "Namegroup" => "0000000001",
          "PhoneNumber" => nil,
          "NoChecksInWebCashReceipts" => "N",
          "CellPhoneNumber" => nil,
          "SCRIELease" => nil,
          "Minor" => "False"
        }
      ]
    }
  end

  before do
    # Mock the API client
    allow(handler.api_client).to receive(:get).and_return(response_body)
  end

  describe "#execute" do
    context "with property_id parameter" do
      it "calls the API with the correct parameters" do
        expect(handler.api_client).to receive(:get).with(
          api_endpoint,
          { "RMPROPID" => property_id }
        )

        handler.execute(property_id: property_id)
      end

      it "returns a hash with leases and next_link information" do
        result = handler.execute(property_id: property_id)

        expect(result).to be_a(Hash)
        expect(result).to have_key(:values)
        expect(result).to have_key(:next_link)

        leases = result[:values]
        expect(leases).to be_an(Array)
        expect(leases.size).to eq(2)
        expect(leases.first).to be_a(MriHook::Models::Lease)
        expect(leases.first.resident_name_id).to eq("0000000001")
        expect(leases.last.resident_name_id).to eq("0000000002")

        expect(result[:next_link]).to eq(response_body['nextLink'])
      end
    end

    context "with last_update_date parameter" do
      it "calls the API with the correct parameters" do
        expect(handler.api_client).to receive(:get).with(
          api_endpoint,
          { "LastUpdateDate" => last_update_date }
        )

        handler.execute(last_update_date: last_update_date)
      end
    end

    context "with start_date and end_date parameters" do
      it "calls the API with the correct parameters" do
        expect(handler.api_client).to receive(:get).with(
          api_endpoint,
          { "StartDate" => start_date, "EndDate" => end_date }
        )

        handler.execute(start_date: start_date, end_date: end_date)
      end
    end

    context "with pagination parameters" do
      it "passes top and skip parameters to the API" do
        expect(handler.api_client).to receive(:get).with(
          api_endpoint,
          { "RMPROPID" => property_id, top: 50, skip: 100 }
        )

        handler.execute(property_id: property_id, top: 50, skip: 100)
      end
    end

    context "with missing required parameters" do
      it "raises an ArgumentError when no parameters are provided" do
        expect { handler.execute }.to raise_error(ArgumentError, /Required parameters missing/)
      end

      it "raises an ArgumentError when only start_date is provided" do
        expect { handler.execute(start_date: start_date) }.to raise_error(ArgumentError, /end_date is required/)
      end
    end

    context "when the API returns no leases" do
      before do
        allow(handler.api_client).to receive(:get).and_return({ "value" => [] })
      end

      it "returns a hash with empty values and nil next_link" do
        result = handler.execute(property_id: property_id)

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
        result = handler.execute(property_id: property_id)

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
