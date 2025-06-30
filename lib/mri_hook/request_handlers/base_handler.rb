# frozen_string_literal: true

module MriHook
  module RequestHandlers
    class BaseHandler
      attr_reader :api_client

      def initialize
        @api_client = MriHook::ApiClient.new
      end

      def execute(params = {})
        raise NotImplementedError, "Subclasses must implement the execute method"
      end

      protected

      def api_endpoint
        raise NotImplementedError, "Subclasses must define the API_ENDPOINT constant"
      end
    end
  end
end
