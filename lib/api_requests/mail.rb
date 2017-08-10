class ApiRequest
  class Mail
    attr_reader :mail_fields

    def initialize(request)
      @request = request
      @mail_fields = {}
    end

    def to(recipient)
      @mail_fields[:to] = recipient
      self
    end

    def from(sender)
      @mail_fields[:from] = sender
      self
    end

    def with(**params)
      @mail_fields.merge!(params)
      self
    end

    def method_missing(method, *args, &block)
      @request.send(method, *args, &block)
    end
  end
end
