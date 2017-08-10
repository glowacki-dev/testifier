require 'acceptance_helper'

resource 'Posts' do
  explanation 'Posts are entities holding some text information.
               They can be created and seen by anyone'

  get '/posts/:post_id' do
    parameter :post_id, 'Id of a post we want to show', required: true

    response_field :title, 'Title of a post'
    response_field :body, 'Main text of a post'

    header 'Accept', 'application/json'
    header 'Content-Type', 'application/json'

    let(:title) { 'Foo' }
    let(:body) { 'Lorem ipsum dolor sit amet' }
    let(:post) { Post.create(title: title, body: body) }
    let(:post_id) { post.id }


    subject do
      requests = []

      requests << ApiRequest.test.success
                            .response(:id, title: title, body: body)
                            .and do |response|
        expect(response[:body].length).to be > 10
      end

      requests << ApiRequest.test.failure(404)
                            .with(post_id: 0)

      requests
    end

    include_examples 'api_requests',
                     'Showing a post',
                     'You can see a single post by requesting it with its id'
  end
end
