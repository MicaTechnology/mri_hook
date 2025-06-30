# frozen_string_literal: true

require "spec_helper"

RSpec.describe MriHook::Models::Lease do
  let(:lease_data) do
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
    }
  end

  subject { described_class.new(lease_data) }

  describe "#initialize" do
    it "sets attributes from the data" do
      expect(subject.resident_name_id).to eq("0000000001")
      expect(subject.property_id).to eq("GCNS01")
      expect(subject.building_id).to eq("01")
      expect(subject.unit_id).to eq("101")
      expect(subject.lease_id).to eq("1")
      expect(subject.address).to eq("Av. Revolución 2703")
      expect(subject.building_address).to be_nil
      expect(subject.city).to be_nil
      expect(subject.state).to be_nil
      expect(subject.zipcode).to be_nil
      expect(subject.first_name).to eq("S.A. DE C.V.")
      expect(subject.last_name).to eq("CJ LOGISTICS MEXICO")
      expect(subject.resident_status).to eq("Old")
      expect(subject.email).to be_nil
      expect(subject.birthday).to be_nil
      expect(subject.lease_start).to eq("2019-05-01T00:00:00")
      expect(subject.occupy_date).to eq("2018-01-12T00:00:00")
      expect(subject.lease_end).to eq("2020-04-30T00:00:00")
      expect(subject.lease_monthly_rent_amount).to eq("38300.00")
      expect(subject.lease_move_out).to eq("2020-01-01T00:00:00")
      expect(subject.lease_month_to_month).to eq("N")
      expect(subject.pay_allowed).to be_nil
      expect(subject.last_update_date).to eq("2020-02-25T19:46:00")
      expect(subject.curr_code).to eq("MXN")
      expect(subject.lease_balance).to eq("0.00")
      expect(subject.is_current).to eq("N")
      expect(subject.block_e_payments).to eq("N")
      expect(subject.guarantor).to eq("N")
      expect(subject.lease_term).to eq("12")
      expect(subject.number_of_garages).to be_nil
      expect(subject.date_notified).to eq("2020-01-01T00:00:00")
      expect(subject.vacate_reason).to eq("TR")
      expect(subject.number_of_units).to eq("200")
      expect(subject.description).to eq("Main Building")
      expect(subject.has_pet).to eq("N")
      expect(subject.resident_vacate_date).to eq("2020-01-01T00:00:00")
      expect(subject.number_of_occupants).to be_nil
      expect(subject.name_group).to eq("0000000001")
      expect(subject.phone_number).to be_nil
      expect(subject.no_checks_in_web_cash_receipts).to eq("N")
      expect(subject.cell_phone_number).to be_nil
      expect(subject.scrie_lease).to be_nil
      expect(subject.minor).to eq("False")
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

  describe "#current?" do
    context "when is_current is 'Y'" do
      before { subject.is_current = "Y" }

      it "returns true" do
        expect(subject.current?).to be true
      end
    end

    context "when is_current is not 'Y'" do
      before { subject.is_current = "N" }

      it "returns false" do
        expect(subject.current?).to be false
      end
    end
  end

  describe "#month_to_month?" do
    context "when lease_month_to_month is 'Y'" do
      before { subject.lease_month_to_month = "Y" }

      it "returns true" do
        expect(subject.month_to_month?).to be true
      end
    end

    context "when lease_month_to_month is not 'Y'" do
      before { subject.lease_month_to_month = "N" }

      it "returns false" do
        expect(subject.month_to_month?).to be false
      end
    end
  end

  describe "#has_pet?" do
    context "when has_pet is 'Y'" do
      before { subject.has_pet = "Y" }

      it "returns true" do
        expect(subject.has_pet?).to be true
      end
    end

    context "when has_pet is not 'Y'" do
      before { subject.has_pet = "N" }

      it "returns false" do
        expect(subject.has_pet?).to be false
      end
    end
  end

  describe "#monthly_rent" do
    it "returns the lease monthly rent amount as a float" do
      expect(subject.monthly_rent).to eq(38300.00)
    end
  end

  describe "#balance" do
    it "returns the lease balance as a float" do
      expect(subject.balance).to eq(0.00)
    end
  end
end
