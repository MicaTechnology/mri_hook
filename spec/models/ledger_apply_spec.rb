# frozen_string_literal: true

require "spec_helper"

RSpec.describe MriHook::Models::LedgerApply do
  let(:ledger_apply_data) do
    {
      "ResidentID" => "0000010449",
      "PropertyID" => "GCCH01",
      "Amount" => "-14360.17",
      "OriginalTransaction" => "0000788350",
      "PostedTransaction" => "0000774767"
    }
  end

  subject { described_class.new(ledger_apply_data) }

  describe "#initialize" do
    it "sets attributes from the data" do
      expect(subject.resident_id).to eq("0000010449")
      expect(subject.property_id).to eq("GCCH01")
      expect(subject.amount).to eq("-14360.17")
      expect(subject.original_transaction).to eq("0000788350")
      expect(subject.posted_transaction).to eq("0000774767")
    end
  end

  describe "#amount_value" do
    it "returns the amount as a float" do
      expect(subject.amount_value).to eq(-14360.17)
    end

    context "when the amount is positive" do
      before { subject.amount = "165.52" }

      it "keeps the sign" do
        expect(subject.amount_value).to eq(165.52)
      end
    end
  end

  describe "#applied_amount" do
    it "returns the magnitude of a negative amount" do
      expect(subject.applied_amount).to eq(14360.17)
    end

    # MRI signs Amount to match OriginalTransaction, so a row whose original side is the charge
    # comes back positive. Both directions settle the same magnitude.
    context "when the original transaction is the charge" do
      before { subject.amount = "165.52" }

      it "returns the same magnitude" do
        expect(subject.applied_amount).to eq(165.52)
      end
    end
  end

  describe "#transaction_ids" do
    it "returns both sides of the pair" do
      expect(subject.transaction_ids).to eq(%w[0000788350 0000774767])
    end
  end

  describe "#counterpart_of" do
    it "returns the posted transaction when given the original" do
      expect(subject.counterpart_of("0000788350")).to eq("0000774767")
    end

    it "returns the original transaction when given the posted" do
      expect(subject.counterpart_of("0000774767")).to eq("0000788350")
    end

    it "returns nil when the transaction is not part of the row" do
      expect(subject.counterpart_of("0000755139")).to be_nil
    end
  end
end
