# frozen_string_literal: true

require "spec_helper"

RSpec.describe MriHook::Models::PendingMoveIn do
  let(:previous_address_data) do
    {
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
  end

  let(:pending_move_in_data) do
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
        "entry" => previous_address_data
      }
    }
  end

  let(:pending_move_in_with_multiple_addresses_data) do
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
        "entry" => [
          previous_address_data,
          {
            "ResidentID" => "00S0009003",
            "Address1" => "Another Address",
            "Address2" => "Another Detail",
            "Address3" => nil,
            "City" => "Mexico City",
            "State" => "CDMX",
            "Zip" => "12345",
            "Country" => "MX",
            "Phone" => nil
          }
        ]
      }
    }
  end

  let(:pending_move_in_without_address_data) do
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
      "Phone" => nil
    }
  end

  describe "#initialize" do
    context "with a single previous address" do
      subject { described_class.new(pending_move_in_data) }

      it "sets attributes from the data" do
        expect(subject.resident_id).to eq("00S0009003")
        expect(subject.first_name).to eq("MICA TESTING")
        expect(subject.last_name).to eq("MICA TESTING")
        expect(subject.property_id).to eq("GCCH02")
        expect(subject.building_id).to eq("01")
        expect(subject.unit_id).to eq("0809")
        expect(subject.lease_id).to eq("2")
        expect(subject.resident_status).to eq("New")
        expect(subject.scheduled_move_in_date).to eq("2025-06-18T00:00:00.0000000")
        expect(subject.email).to eq("jlegorreta@granciudad.mx")
        expect(subject.phone).to be_nil
      end

      it "creates a PreviousAddress object for the previous address" do
        expect(subject.previous_addresses).to be_an(Array)
        expect(subject.previous_addresses.size).to eq(1)
        expect(subject.previous_addresses.first).to be_a(MriHook::Models::PreviousAddress)
        expect(subject.previous_addresses.first.resident_id).to eq("00S0009003")
        expect(subject.previous_addresses.first.address1).to eq("Calle Paraiso")
      end
    end

    context "with multiple previous addresses" do
      subject { described_class.new(pending_move_in_with_multiple_addresses_data) }

      it "creates PreviousAddress objects for each previous address" do
        expect(subject.previous_addresses).to be_an(Array)
        expect(subject.previous_addresses.size).to eq(2)
        expect(subject.previous_addresses.first).to be_a(MriHook::Models::PreviousAddress)
        expect(subject.previous_addresses.first.resident_id).to eq("00S0009003")
        expect(subject.previous_addresses.first.address1).to eq("Calle Paraiso")
        expect(subject.previous_addresses.last).to be_a(MriHook::Models::PreviousAddress)
        expect(subject.previous_addresses.last.address1).to eq("Another Address")
      end
    end

    context "without previous addresses" do
      subject { described_class.new(pending_move_in_without_address_data) }

      it "initializes an empty array for previous_addresses" do
        expect(subject.previous_addresses).to be_an(Array)
        expect(subject.previous_addresses).to be_empty
      end
    end
  end

  describe "#full_name" do
    subject { described_class.new(pending_move_in_data) }

    it "returns the full name" do
      expect(subject.full_name).to eq("MICA TESTING MICA TESTING")
    end

    context "when first_name is nil" do
      before { subject.first_name = nil }

      it "returns just the last name" do
        expect(subject.full_name).to eq("MICA TESTING")
      end
    end

    context "when last_name is nil" do
      before { subject.last_name = nil }

      it "returns just the first name" do
        expect(subject.full_name).to eq("MICA TESTING")
      end
    end
  end

  describe "#primary_previous_address" do
    context "with previous addresses" do
      subject { described_class.new(pending_move_in_data) }

      it "returns the first previous address" do
        expect(subject.primary_previous_address).to be_a(MriHook::Models::PreviousAddress)
        expect(subject.primary_previous_address.address1).to eq("Calle Paraiso")
      end
    end

    context "without previous addresses" do
      subject { described_class.new(pending_move_in_without_address_data) }

      it "returns nil" do
        expect(subject.primary_previous_address).to be_nil
      end
    end
  end
end
