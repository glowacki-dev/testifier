class ApiRequest
  class Stub
    attr_reader :data

    def initialize(request = nil)
      @request = request
    end

    def twitter
      @stubber = TwitterStubber.new(self)
    end

    def facebook
      @stubber = FacebookStubber.new(self)
    end

    def finish_stubbing
      @data = WebMock::RequestStub.new(@stubber.method, @stubber.uri)
      @data.with(@stubber.request_body) if @stubber.request_body
      @data.to_return(@stubber.response)
      @request
    end
  end
end
