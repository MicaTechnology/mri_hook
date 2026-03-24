# frozen_string_literal: true

require "spec_helper"

RSpec.describe MriHook::ApiClient do
  let(:client) { described_class.new }
  let(:api_endpoint) { "MRI_S-PMRM_ResidentLedger" }
  let(:response_body) { { "value" => [{ "TransactionID" => "001" }] }.to_json }

  let(:next_link_with_cursor) do
    {
      "nextLink" => "https://mrix5api.saas.mrisoftware.com/mriapiservices/api.asp?%24api=MRI_S-PMRM_ResidentLedger&%24format=json&STARTDATE=2024-09-01&ENDDATE=2026-12-28&NAMEID=0000007854&PROPERTYID=GCCH02&_next=ae4940b2ae3c4f29",
      "value" => [{ "TransactionID" => "001" }]
    }.to_json
  end

  let(:next_link_with_top_skip) do
    {
      "nextLink" => "https://mrix5api.saas.mrisoftware.com/mriapiservices/api.asp?%24api=MRI_S-PMRM_ResidentsByPropertyID&%24format=json&RMPROPID=GCNS01&%24top=1000&%24skip=1001",
      "value" => [{ "TransactionID" => "001" }]
    }.to_json
  end

  before do
    allow(RestClient::Request).to receive(:execute).and_return(
      double(body: response_body)
    )
  end

  describe "#get" do
    it "builds URL from endpoint and params" do
      client.get(api_endpoint, { "STARTDATE" => "2024-01-01" })

      expect(RestClient::Request).to have_received(:execute).with(
        hash_including(url: a_string_including("$api=#{api_endpoint}", "STARTDATE=2024-01-01"))
      )
    end

    it "converts :top to $top" do
      client.get(api_endpoint, { top: 100 })

      expect(RestClient::Request).to have_received(:execute).with(
        hash_including(url: a_string_including("$top=100"))
      )
    end

    it "converts :skip to $skip" do
      client.get(api_endpoint, { skip: 200 })

      expect(RestClient::Request).to have_received(:execute).with(
        hash_including(url: a_string_including("$skip=200"))
      )
    end

    it "converts :_next to _next" do
      client.get(api_endpoint, { _next: "abc123token" })

      expect(RestClient::Request).to have_received(:execute).with(
        hash_including(url: a_string_including("_next=abc123token"))
      )
    end

    it "extracts _next from nextLink into next_link hash" do
      allow(RestClient::Request).to receive(:execute).and_return(
        double(body: next_link_with_cursor)
      )

      result = client.get(api_endpoint, {})

      expect(result['next_link'][:_next]).to eq("ae4940b2ae3c4f29")
      expect(result['next_link'][:top]).to be_nil
      expect(result['next_link'][:skip]).to be_nil
    end

    it "extracts $top and $skip from nextLink into next_link hash" do
      allow(RestClient::Request).to receive(:execute).and_return(
        double(body: next_link_with_top_skip)
      )

      result = client.get(api_endpoint, {})

      expect(result['next_link'][:top]).to eq("1000")
      expect(result['next_link'][:skip]).to eq("1001")
      expect(result['next_link'][:_next]).to be_nil
    end

    it "sends auth credentials" do
      client.get(api_endpoint, {})

      expect(RestClient::Request).to have_received(:execute).with(
        hash_including(user: anything, password: anything)
      )
    end
  end

  describe "#initialize" do
    it "uses provided credentials over ENV vars" do
      custom_client = described_class.new(
        base_domain: "https://custom.mri.com",
        base_endpoint: "/custom/api.asp",
        username: "custom_user",
        password: "custom_pass"
      )

      expect(custom_client.base_url).to eq("https://custom.mri.com/custom/api.asp")

      custom_client.get(api_endpoint, {})

      expect(RestClient::Request).to have_received(:execute).with(
        hash_including(
          user: "custom_user",
          password: "custom_pass",
          url: a_string_including("https://custom.mri.com/custom/api.asp")
        )
      )
    end

    it "falls back to ENV vars when no arguments provided" do
      expect(client.base_url).to eq("#{ENV.fetch('BASE_MRI_DOMAIN')}#{ENV.fetch('BASE_MRI_API_ENDPOINT')}")
    end
  end
end
