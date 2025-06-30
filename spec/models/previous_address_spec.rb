# frozen_string_literal: true

require "spec_helper"

RSpec.describe MriHook::Models::PreviousAddress do
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

  subject { described_class.new(previous_address_data) }

  describe "#initialize" do
    it "sets attributes from the data" do
      expect(subject.resident_id).to eq("00S0009003")
      expect(subject.address1).to eq("Calle Paraiso")
      expect(subject.address2).to eq("Col Centro")
      expect(subject.address3).to be_nil
      expect(subject.city).to eq("Guanajuato")
      expect(subject.state).to eq("GT")
      expect(subject.zip).to eq("38900")
      expect(subject.country).to eq("MX")
      expect(subject.phone).to be_nil
    end
  end

  describe "#full_address" do
    it "returns the full address as a string" do
      expect(subject.full_address).to eq("Calle Paraiso, Col Centro, Guanajuato, GT, 38900, MX")
    end

    context "when some address fields are nil or empty" do
      before do
        subject.address2 = ""
        subject.address3 = nil
        subject.country = nil
      end

      it "excludes nil or empty fields from the full address" do
        expect(subject.full_address).to eq("Calle Paraiso, Guanajuato, GT, 38900")
      end
    end

    context "when all address fields are nil or empty" do
      before do
        subject.address1 = nil
        subject.address2 = ""
        subject.address3 = nil
        subject.city = nil
        subject.state = nil
        subject.zip = nil
        subject.country = nil
      end

      it "returns an empty string" do
        expect(subject.full_address).to eq("")
      end
    end
  end
end
