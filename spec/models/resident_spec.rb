# frozen_string_literal: true

require "spec_helper"

RSpec.describe MriHook::Models::Resident do
  let(:residents_by_property_data) do
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
    }
  end

  let(:residents_data) do
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
  end

  subject { described_class.new(residents_by_property_data) }

  describe "#initialize" do
    context "with ResidentsByPropertyID data" do
      it "sets attributes from the data" do
        resident = described_class.new(residents_by_property_data)

        expect(resident.resident_name_id).to eq("0000000001")
        expect(resident.property_id).to eq("GCNS01")
        expect(resident.building_id).to eq("01")
        expect(resident.unit_id).to eq("101")
        expect(resident.lease_id).to eq("1")
        expect(resident.resident_type).to eq("R")
        expect(resident.status).to eq("O")
        expect(resident.first_name).to eq("S.A. DE C.V.")
        expect(resident.last_name).to eq("CJ LOGISTICS MEXICO")
        expect(resident.phone_number).to be_nil
        expect(resident.email).to be_nil
        expect(resident.occupy_date).to eq("2018-01-12T00:00:00")
        expect(resident.last_update_date).to eq("2020-02-25T00:00:00")
        expect(resident.name_group).to eq("0000000001")
        expect(resident.work_phone1).to be_nil
        expect(resident.work_phone2).to be_nil
        expect(resident.cell).to be_nil
        expect(resident.vacate_date).to eq("2020-01-01T00:00:00")
      end
    end

    context "with Residents data" do
      it "sets attributes from the data" do
        resident = described_class.new(residents_data)

        # Check common fields
        expect(resident.property_id).to eq("GCNS01")
        expect(resident.building_id).to eq("01")
        expect(resident.unit_id).to eq("412")
        expect(resident.lease_id).to eq("1")
        expect(resident.first_name).to eq("CARLOS")
        expect(resident.last_name).to eq("ROMERO USCANGA")
        expect(resident.phone_number).to be_nil
        expect(resident.work_phone1).to be_nil
        expect(resident.work_phone2).to be_nil
        expect(resident.cell).to be_nil
        expect(resident.occupy_date).to eq("2017-01-01T00:00:00")
        expect(resident.vacate_date).to eq("2023-12-31T00:00:00")
        expect(resident.last_update_date).to eq("2024-01-02T17:37:25")

        # Check new fields
        expect(resident.resident_name_id).to eq("0000000298")
        expect(resident.prospect_applicant_resident).to eq("R")
        expect(resident.name_status).to eq("*")
        expect(resident.status).to eq("*")
        expect(resident.middle_initial).to eq("1")
        expect(resident.comment).to be_nil
        expect(resident.sex).to be_nil
        expect(resident.who).to eq("SS")
        expect(resident.qualified).to eq("N")
        expect(resident.previous_residence).to eq("R")
        expect(resident.occupation).to be_nil
        expect(resident.income).to eq("@@")
        expect(resident.guarantor).to eq("N")
        expect(resident.location).to eq("C")
        expect(resident.marketing_id).to be_nil
        expect(resident.leasing_agent_id).to be_nil
        expect(resident.company_name).to be_nil
        expect(resident.job_title).to be_nil
        expect(resident.job_years).to be_nil
        expect(resident.number_of_nsf_payments).to eq("0")
        expect(resident.number_of_late_payments).to eq("0")
        expect(resident.payments_allowed).to be_nil
        expect(resident.user_id).to eq("GRCLQ11")
        expect(resident.primary_name_id).to eq("0000000297")
        expect(resident.residents_property_id).to eq("GCNS01")
        expect(resident.identified_as_affordable_housing).to be_nil
        expect(resident.date_placed_on_ah_waiting_list).to be_nil
        expect(resident.ah_waiting_list_sequence_number).to eq("0")
        expect(resident.marital_status).to eq("N")
        expect(resident.previous_name_id).to be_nil
        expect(resident.size_of_unit).to eq("00")
        expect(resident.query_flag).to be_nil
        expect(resident.email_address).to be_nil
        expect(resident.status_based_on_credit_report_results).to be_nil
        expect(resident.public_assistance_id).to be_nil
        expect(resident.fax).to be_nil
        expect(resident.tab_id).to be_nil
        expect(resident.move_in_reason).to be_nil
        expect(resident.number_of_residents).to eq("0")
        expect(resident.ssno_not_available).to eq("N")
        expect(resident.background_check_status).to eq("U")
        expect(resident.other_resident_background_check_required).to be_nil
        expect(resident.follow_up_on_background_check).to be_nil
        expect(resident.no_checks_in_web_cash_receipts).to eq("N")
        expect(resident.occupant_inactive).to be_nil
        expect(resident.tax_credit_resident).to be_nil
        expect(resident.tax_credit_certified).to be_nil
        expect(resident.auto_spread_concessions).to eq("N")
        expect(resident.opt_out_of_check_scanning).to be_nil
        expect(resident.exclude_resident_from_utility_billing).to be_nil
        expect(resident.utility_billing_override_date).to be_nil
        expect(resident.record_created_by_call_center_agent).to be_nil
        expect(resident.renewal_lease_type).to be_nil
        expect(resident.rent_increase_summary_type).to be_nil
        expect(resident.identified_as_student_housing).to be_nil
        expect(resident.exclude_utility_billing).to be_nil
        expect(resident.social_security_number).to be_nil
        expect(resident.license_number).to be_nil
        expect(resident.bank_account).to be_nil
        expect(resident.personal_phone).to be_nil
        expect(resident.employment_monthly_income).to eq("0.0000")
        expect(resident.provider_screening_status).to be_nil
      end
    end
  end

  describe "#full_name" do
    it "returns the full name" do
      expect(subject.full_name).to eq("S.A. DE C.V. CJ LOGISTICS MEXICO")
    end

    context "when first_name is nil" do
      before { subject.first_name = nil }

      it "returns just the last name" do
        expect(subject.full_name).to eq("CJ LOGISTICS MEXICO")
      end
    end

    context "when last_name is nil" do
      before { subject.last_name = nil }

      it "returns just the first name" do
        expect(subject.full_name).to eq("S.A. DE C.V.")
      end
    end
  end

  describe "#active?" do
    context "when status is 'R'" do
      before { subject.status = "R" }

      it "returns true" do
        expect(subject.active?).to be true
      end
    end

    context "when status is not 'R'" do
      before { subject.status = "O" }

      it "returns false" do
        expect(subject.active?).to be false
      end
    end
  end

  describe "#owner?" do
    context "when status is 'O'" do
      before { subject.status = "O" }

      it "returns true" do
        expect(subject.owner?).to be true
      end
    end

    context "when status is not 'O'" do
      before { subject.status = "R" }

      it "returns false" do
        expect(subject.owner?).to be false
      end
    end
  end
end
