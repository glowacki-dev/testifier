class AbstractStubber
  attr_reader :method, :uri, :request_body

  def initialize(stub)
    @stub = stub
    @method = nil
    @uri = nil
    @request_body = nil
    @with = {}
    @responses = default_responses
  end

  def response
    {
      status: @responses[@trait][:status],
      body: @responses[@trait][:body].to_json
    }
  end

  def success
    @trait = :success
    @stub.finish_stubbing
  end

  def failure
    @trait = :failure
    @stub.finish_stubbing
  end

  def with(**params)
    @with.merge!(params)
    self
  end

  def method_missing(method)
    method = method.to_sym
    return @with[method] if @with.key?(method)

    raise ArgumentError,
          "You must provide a valid #{method} using "\
          ".with(#{method}: valid_#{method})"
  end

  private

    def default_responses
      {}
    end
end
