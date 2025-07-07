# frozen_string_literal: true

require "spec_helper"

RSpec.describe MriHook::Models::LedgerTransaction do
  let(:ledger_transaction_data) do
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
  end

  subject { described_class.new(ledger_transaction_data) }

  describe "#initialize" do
    it "sets attributes from the data" do
      expect(subject.transaction_id).to eq("00000526PP")
      expect(subject.property_id).to eq("GCCH01")
      expect(subject.resident_name_id).to eq("0000009006")
      expect(subject.transaction_date).to eq("2024-02-22T00:00:00")
      expect(subject.charge_code).to eq("RNI")
      expect(subject.source_code).to eq("CR")
      expect(subject.cash_type).to eq("VM")
      expect(subject.description).to eq("Custom Description")
      expect(subject.transaction_amount).to eq("-1000.00")
      expect(subject.open_amount).to eq("0.00")
      expect(subject.receipt_descriptor).to eq("1232_3")
      expect(subject.reference_number).to eq("0000496133")
      expect(subject.posted).to eq("Y")
      expect(subject.name_group).to eq("0000009006")
    end
  end

  describe "#posted?" do
    context "when posted is 'Y'" do
      before { subject.posted = "Y" }

      it "returns true" do
        expect(subject.posted?).to be true
      end
    end

    context "when posted is not 'Y'" do
      before { subject.posted = "N" }

      it "returns false" do
        expect(subject.posted?).to be false
      end
    end
  end

  describe "#transaction_amount_value" do
    it "returns the transaction amount as a float" do
      expect(subject.transaction_amount_value).to eq(-1000.00)
    end
  end

  describe "#open_amount_value" do
    it "returns the open amount as a float" do
      expect(subject.open_amount_value).to eq(0.00)
    end
  end

  describe "#payment?" do
    context "when transaction amount is negative" do
      before { subject.transaction_amount = "-1000.00" }

      it "returns true" do
        expect(subject.payment?).to be true
      end
    end

    context "when transaction amount is positive" do
      before { subject.transaction_amount = "1000.00" }

      it "returns false" do
        expect(subject.payment?).to be false
      end
    end

    context "when transaction amount is zero" do
      before { subject.transaction_amount = "0.00" }

      it "returns false" do
        expect(subject.payment?).to be false
      end
    end
  end

  describe "#charge?" do
    context "when transaction amount is positive" do
      before { subject.transaction_amount = "1000.00" }

      it "returns true" do
        expect(subject.charge?).to be true
      end
    end

    context "when transaction amount is negative" do
      before { subject.transaction_amount = "-1000.00" }

      it "returns false" do
        expect(subject.charge?).to be false
      end
    end

    context "when transaction amount is zero" do
      before { subject.transaction_amount = "0.00" }

      it "returns false" do
        expect(subject.charge?).to be false
      end
    end
  end
end
