require 'acceptance_helper'

resource 'Posts' do
  explanation 'Posts are entities holding some text information.
               They can be created and seen by anyone'

  post '/posts' do
    with_options scope: :post do
      parameter :title, 'Title of a post. Can be empty'
      parameter :body, 'Main text of a post. Must be longer than 10 letters', required: true
    end

    response_field :id, 'Id of the created post'
    response_field :title, 'Title of the created post'
    response_field :body, 'Main text of the created post'

    let(:title) { 'Foo' }
    let(:body) { 'Lorem ipsum dolor sit amet' }

    subject do
      requests = []

      requests << ApiRequest.test.success(201)
                            .response(:id, title: title, body: body)
                            .email.to('notify@cia.gov').with(
                              subject: 'New Post published',
                              body: body)
                            .request.twitter.with(status: body).status_update.success
                            .request.facebook.with(message: body).put_wall_post.success
                            .and do
        expect(Post.count).to eq(1)
        post = Post.last
        expect(post.title).to eq(title)
        expect(post.body).to eq(body)
      end

      requests << ApiRequest.test.failure
                    .with(post: { body: nil })
                    .response(body: ['001', '002'])
                    .and do
        expect(Post.count).to eq(1)
      end

      requests << ApiRequest.test.failure
                            .with(post: { body: 'Too short' })
                            .response(body: ['002'])
                            .and do
        expect(Post.count).to eq(1)
      end

      requests
    end

    include_examples 'api_requests',
                     'Creating a post',
                     'You can create a post by sending its body text and an optional title'
  end
end
