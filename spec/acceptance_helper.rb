require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'
require 'api_requests/base'

RspecApiDocumentation.configure do |config|
  config.format = %i[json]
  config.curl_host = 'http://example.com'
  config.api_name = 'Example API'
  config.request_body_formatter = proc { |params| params.to_json }
  config.curl_headers_to_filter = %w[Cookie Host]
  config.request_headers_to_include = %w[Content-Type Referer]
  config.response_headers_to_include = %w[Content-Type]
end
