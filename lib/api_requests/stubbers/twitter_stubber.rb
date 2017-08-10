class TwitterStubber < AbstractStubber
  def status_update
    @method = :post
    @uri = 'https://api.twitter.com/1.1/statuses/update.json'
    @request_body = {
      body: WebMock::API.hash_including(status: status)
    }
    @responses[:success] = {
      status: 200,
      body: {
        id: 1
      }
    }
    self
  end

  private

    def default_responses
      {
        failure: {
          status: 401,
          body: {
            errors: [{ code: 32, message: 'Could not authenticate you' }]
          }
        }
      }
    end
end
