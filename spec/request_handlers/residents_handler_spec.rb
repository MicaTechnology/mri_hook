# frozen_string_literal: true

require "spec_helper"

RSpec.describe MriHook::RequestHandlers::ResidentsHandler do
  let(:handler) { described_class.new }
  let(:api_endpoint) { "MRI_S-PMRM_Residents" }

  let(:old_response_body) do
    {
      "odata.metadata" => "https://mrix5api.saas.mrisoftware.com/mriapiservices/api.asp?$api=MRI_S-PMRM_Residents&$metadata#MRI.mri_s-pmrm_residents-container/mri_s-pmrm_residents",
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

  let(:new_response_body) do
    {
      "odata.metadata" => "https://mrix5api.saas.mrisoftware.com/mriapiservices/api.asp?$api=MRI_S-PMRM_Residents&$metadata#MRI.mri_s-pmrm_residents-container/mri_s-pmrm_residents",
      "nextLink" => "https://mrix5api.saas.mrisoftware.com/mriapiservices/api.asp?%24api=MRI_S-PMRM_Residents&%24format=json&IncludePII=Y&NameId=0000000298&%24top=300&%24skip=301",
      "value" => [
        {
          "NameId" => "0000000298",
          "ProspectApplicantResident" => "R",
          "NameStatus" => "*",
          "PropertyId" => "GCNS01",
          "Birthday" => nil,
          "LastName" => "ROMERO USCANGA",
          "FirstName" => "CARLOS",
          "MiddleInitial" => "1",
          "PhoneNumber" => nil,
          "Comment" => nil,
          "Sex" => nil,
          "Who" => "SS",
          "Qualified" => "N",
          "PreviousResidence" => "R",
          "Occupation" => nil,
          "Income" => "@@",
          "Guarantor" => "N",
          "Location" => "C",
          "MarketingId" => nil,
          "LeasingAgentId" => nil,
          "CompanyName" => nil,
          "JobTitle" => nil,
          "JobYears" => nil,
          "NumberOfNSFPayments" => "0",
          "NumberOfLatePayments" => "0",
          "PaymentsAllowed" => nil,
          "LastUpdate" => "2024-01-02T17:37:25",
          "UserId" => "GRCLQ11",
          "PrimaryNameId" => "0000000297",
          "ResidentsPropertyId" => "GCNS01",
          "BuildingId" => "01",
          "UnitId" => "412",
          "LeaseId" => "1",
          "IdentifiedAsAffordableHousing" => nil,
          "DatePlacedOnAHWaitingList" => nil,
          "AHWaitingListSequenceNumber" => "0",
          "MaritalStatus" => "N",
          "PreviousNameId" => nil,
          "SizeOfUnit" => "00",
          "QueryFlag" => nil,
          "EMailAddress" => nil,
          "StatusBasedOnCreditReportResults" => nil,
          "PublicAssistanceID" => nil,
          "OccupantOccupyDate" => "2017-01-01T00:00:00",
          "OccupantVacateDate" => "2023-12-31T00:00:00",
          "WorkPhone1" => nil,
          "WorkPhone2" => nil,
          "Cell" => nil,
          "Fax" => nil,
          "TabId" => nil,
          "MoveInReason" => nil,
          "NumberOfResidents" => "0",
          "SSNONotAvailable" => "N",
          "BackgroundCheckStatus" => "U",
          "OtherResidentBackgroundCheckRequired" => nil,
          "FollowUpOnBackgroundCheck" => nil,
          "NoChecksInWebCashReceipts" => "N",
          "OccupantInactive" => nil,
          "TaxCreditResident" => nil,
          "TaxCreditCertified" => nil,
          "AutoSpreadConcessions" => "N",
          "OptOutOfCheckScanning" => nil,
          "ExcludeResidentFromUtilityBilling" => nil,
          "UtilityBillingOverrideDate" => nil,
          "RecordCreatedByCallCenterAgent" => nil,
          "RenewalLeaseType" => nil,
          "RentIncreaseSummaryType" => nil,
          "IdentifiedAsStudentHousing" => nil,
          "ExcludeUtilityBilling" => nil,
          "SocialSecurityNumber" => nil,
          "LicenseNumber" => nil,
          "BankAccount" => nil,
          "PersonalPhone" => nil,
          "EmploymentMonthlyIncome" => "0.0000",
          "ProviderScreeningStatus" => nil
        }
      ]
    }
  end

  let(:response_body) { old_response_body }

  before do
    # Mock the API client
    allow(handler.api_client).to receive(:get).and_return(response_body)
  end

  describe "#execute" do
    context "with last_update parameter" do
      let(:last_update) { "01-01-2024" }

      it "calls the API with the correct parameters" do
        expect(handler.api_client).to receive(:get).with(
          api_endpoint,
          { "LastUpdate" => last_update, "IncludePII" => "Y" }
        )

        handler.execute(last_update: last_update)
      end

      it "returns an array of Resident objects" do
        residents = handler.execute(last_update: last_update)

        expect(residents).to be_an(Array)
        expect(residents.size).to eq(2)
        expect(residents.first).to be_a(MriHook::Models::Resident)
        expect(residents.first.resident_name_id).to eq("0000000001")
        expect(residents.last.resident_name_id).to eq("0000000002")
      end
    end

    context "with name_id parameter" do
      let(:name_id) { "0000000298" }

      it "calls the API with the correct parameters" do
        expect(handler.api_client).to receive(:get).with(
          api_endpoint,
          { "NameID" => name_id, "IncludePII" => "Y" }
        )

        handler.execute(name_id: name_id)
      end
    end

    context "with start_date and end_date parameters" do
      let(:start_date) { "01-01-2024" }
      let(:end_date) { "01-31-2024" }

      it "calls the API with the correct parameters" do
        expect(handler.api_client).to receive(:get).with(
          api_endpoint,
          { "StartDate" => start_date, "EndDate" => end_date, "IncludePII" => "Y" }
        )

        handler.execute(start_date: start_date, end_date: end_date)
      end
    end

    context "with property_id, type, and status parameters" do
      let(:property_id) { "GCNS01" }
      let(:type) { "R" }
      let(:status) { "O" }

      it "calls the API with the correct parameters" do
        expect(handler.api_client).to receive(:get).with(
          api_endpoint,
          { "PropertyID" => property_id, "Type" => type, "Status" => status, "IncludePII" => "Y" }
        )

        handler.execute(property_id: property_id, type: type, status: status)
      end
    end

    context "with include_pii parameter set to false" do
      let(:last_update) { "01-01-2024" }

      it "calls the API with IncludePII=N" do
        expect(handler.api_client).to receive(:get).with(
          api_endpoint,
          { "LastUpdate" => last_update, "IncludePII" => "N" }
        )

        handler.execute(last_update: last_update, include_pii: false)
      end
    end

    context "with missing required parameters" do
      it "raises an ArgumentError" do
        expect { handler.execute }.to raise_error(ArgumentError, /Required parameters missing/)
      end
    end

    context "with incomplete parameter combinations" do
      it "raises an ArgumentError when only start_date is provided" do
        expect { handler.execute(start_date: "01-01-2024") }.to raise_error(ArgumentError, /Required parameters missing/)
      end

      it "raises an ArgumentError when only property_id and type are provided" do
        expect { handler.execute(property_id: "GCNS01", type: "R") }.to raise_error(ArgumentError, /Required parameters missing/)
      end
    end

    context "when the API returns no residents" do
      before do
        allow(handler.api_client).to receive(:get).and_return({ "value" => [] })
      end

      it "returns an empty array" do
        residents = handler.execute(last_update: "01-01-2024")

        expect(residents).to be_an(Array)
        expect(residents).to be_empty
      end
    end

    context "when the API returns no value key" do
      before do
        allow(handler.api_client).to receive(:get).and_return({})
      end

      it "returns an empty array" do
        residents = handler.execute(last_update: "01-01-2024")

        expect(residents).to be_an(Array)
        expect(residents).to be_empty
      end
    end

    context "with the new response format" do
      before do
        allow(handler.api_client).to receive(:get).and_return(new_response_body)
      end

      it "correctly maps the response to Resident objects" do
        residents = handler.execute(name_id: "0000000298")

        expect(residents).to be_an(Array)
        expect(residents.size).to eq(1)

        resident = residents.first
        expect(resident).to be_a(MriHook::Models::Resident)

        # Check basic fields
        expect(resident.resident_name_id).to eq("0000000298")
        expect(resident.property_id).to eq("GCNS01")
        expect(resident.building_id).to eq("01")
        expect(resident.unit_id).to eq("412")
        expect(resident.lease_id).to eq("1")
        expect(resident.first_name).to eq("CARLOS")
        expect(resident.last_name).to eq("ROMERO USCANGA")

        # Check some new fields
        expect(resident.prospect_applicant_resident).to eq("R")
        expect(resident.name_status).to eq("*")
        expect(resident.middle_initial).to eq("1")
        expect(resident.who).to eq("SS")
        expect(resident.qualified).to eq("N")
        expect(resident.previous_residence).to eq("R")
        expect(resident.income).to eq("@@")
        expect(resident.number_of_nsf_payments).to eq("0")
        expect(resident.number_of_late_payments).to eq("0")
        expect(resident.last_update_date).to eq("2024-01-02T17:37:25")
        expect(resident.user_id).to eq("GRCLQ11")
        expect(resident.primary_name_id).to eq("0000000297")
        expect(resident.marital_status).to eq("N")
        expect(resident.size_of_unit).to eq("00")
        expect(resident.occupy_date).to eq("2017-01-01T00:00:00")
        expect(resident.vacate_date).to eq("2023-12-31T00:00:00")
        expect(resident.number_of_residents).to eq("0")
        expect(resident.ssno_not_available).to eq("N")
        expect(resident.background_check_status).to eq("U")
        expect(resident.no_checks_in_web_cash_receipts).to eq("N")
        expect(resident.auto_spread_concessions).to eq("N")
        expect(resident.employment_monthly_income).to eq("0.0000")
      end
    end
  end
end
