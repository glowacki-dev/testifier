# This shared example is responsible for extracting data out of ApiRequests
# and creating stubs and expects based on them
shared_examples 'api_requests' do |name, explanation|
  # Since we're using this for testing API let's use json by default
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  # This is rspec_api_documentation syntax. It will create new documentation entry
  example name do
    # Here we pass an endpoint description text to the documentation
    explanation explanation

    # subject can be either an Array of ApiRequests or a single ApiRequest
    # We always wrap this in Array for convenience
    Array.wrap(subject).each do |request|
      # Clear ActionMailer deliveries in case there are more emails sent later within same example
      ActionMailer::Base.deliveries = []
      # .stubs hold WebMock::RecordStubs, which we can use for mocking
      request.stubs.each do |stub|
        WebMock::StubRegistry.instance.register_request_stub(stub.data)
      end
      # Passing params to this method allows us to easily override some default parameters
      do_request(request.params)

      # And now for the actual testing
      # First we check if status code matches what was defined in tests
      expect(status).to eq(request.status)
      # Then we can prepare a response for checking its content
      res = JSON.parse(response_body).deep_symbolize_keys
      # We can check for existence of keys
      expect(res).to include(*request.response_keys)
      # and for key-value pairs to see if they're what expected
      request.response_spec.each do |k, v|
        expect(res[k]).to eq(v), "Expected #{k} to equal '#{v}', but got '#{res[k]}'"
      end
      # finally we run those custom tests passed inside .and block
      instance_exec(res, &request.specs)

      # Now, let's test those email. Have we sent as many as we've stubbed?
      expect(ActionMailer::Base.deliveries.count).to eq(request.messages.length)
      # It's also a good idea to check if their content actually matches
      request.messages.each do |message|
        emails = ActionMailer::Base.deliveries.select { |mail| message.mail_fields.all? { |k, v| mail.send(k)&.include?(v) } }
        expect(emails.size).to eq(1), "Expected 1 email to match #{message.mail_fields}, but found #{emails.size}.\nDelivered emails:\n#{ActionMailer::Base.deliveries.inspect}"
      end

      # Finally, we check weather or not we've actually used our web stubs
      # this is a good way to prevent polluting tests with unnecessary stubs
      # After checking, we can remove the stub, so it's not accidentally
      # used in the next example
      request.stubs.each do |stub|
        expect(stub.data).to have_been_requested.at_least_once
        WebMock::StubRegistry.instance.remove_request_stub(stub.data)
      end
    end
  end
end
