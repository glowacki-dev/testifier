class FacebookStubber < AbstractStubber
  def put_wall_post
    @method = :post
    @uri = 'https://graph.facebook.com/me/feed'
    @request_body = {
      body: WebMock::API.hash_including(:access_token,
                                        :appsecret_proof,
                                        message: message)
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
          status: 400,
          body: {
            error: {
              message: 'An active access token must be used to query information about the current user.',
              code: 2500,
            }
          }
        }
      }
    end
end
