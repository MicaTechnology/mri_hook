# frozen_string_literal: true

require 'rest-client'
require 'json'

module MriHook
  class ApiClient
    attr_reader :base_url

    def initialize
      @base_domain = ENV.fetch('BASE_MRI_DOMAIN')
      @base_endpoint = ENV.fetch('BASE_MRI_API_ENDPOINT')
      @base_url = "#{@base_domain}#{@base_endpoint}"
      @username = ENV.fetch('MRI_USERNAME')
      @password = ENV.fetch('MRI_PASSWORD')
      @auth = { username: @username, password: @password }
    end

    def get(api_endpoint, params = {})
      url = build_url(api_endpoint, params)
      headers = { content_type: :json, accept: :json }
      response = RestClient::Request.execute(
        method: :get,
        url: url,
        headers: headers,
        user: @username,
        password: @password
      )
      JSON.parse(response.body)
    rescue RestClient::ExceptionWithResponse => e
      handle_error(e)
    end

    def post(api_endpoint, params = {}, payload = {}, include_metadata: true)
      url = build_url(api_endpoint, params)
      headers = { content_type: :json, accept: :json }

      if include_metadata && !payload.key?('odata.metadata')
        metadata_url = build_metadata_url(api_endpoint)
        payload = {
          'odata.metadata' => metadata_url,
          'value' => payload['value'] || [payload]
        }
      end

      response = RestClient::Request.execute(
        method: :post,
        url: url,
        payload: payload.to_json,
        headers: headers,
        user: @username,
        password: @password
      )
      JSON.parse(response.body)
    rescue RestClient::ExceptionWithResponse => e
      handle_error(e)
    end

    private

    def build_url(api_endpoint, params)
      query_params = { '$api' => api_endpoint, '$format' => 'json' }.merge(params)
      query_string = query_params.map { |k, v| "#{k}=#{v}" }.join('&')
      "#{@base_url}?#{query_string}"
    end

    def build_metadata_url(api_endpoint)
      container_name = api_endpoint.downcase
      "#{@base_url}?$api=#{api_endpoint}&$metadata#MRI.#{container_name}-container/#{container_name}"
    end

    def handle_error(exception)
      error_response = exception.response
      error_body = JSON.parse(error_response.body) rescue {}
      {
        status: error_response.code,
        message: error_body['error'] || error_body['message'] || 'An error occurred'
      }
    end
  end
end
