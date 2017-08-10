class ApiRequest
  attr_reader :status,
              :params,
              :response_keys,
              :response_spec,
              :specs,
              :stubs,
              :messages

  def initialize
    @response_keys = []
    @response_spec = {}
    @specs = proc {}
    @stubs = []
    @messages = []
    @params = {}
  end

  def self.test
    new
  end

  def with(params)
    @params = params
    self
  end

  def success(code = 200)
    @status = code
    self
  end

  def failure(code = 422)
    @status = code
    self
  end

  def response(*extra_keys, **extra_spec)
    @response_keys += extra_keys.map(&:to_sym)
    @response_spec.merge!(extra_spec)
    self
  end

  def request
    @stubs << Stub.new(self)
    @stubs.last
  end

  def email
    @messages << Mail.new(self)
    @messages.last
  end

  def and(&specs)
    @specs = specs
    self
  end
end
