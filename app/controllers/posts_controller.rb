class PostsController < ApplicationController
  before_action :set_post, only: [:show]

  # GET /posts/1
  def show
    if @post
      render json: @post
    else
      render json: {}, status: :not_found
    end
  end

  # POST /posts
  def create
    @post = Post.new(post_params)

    if @post.save
      publish_to_social(@post)
      notify_agencies(@post)
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  private
    def set_post
      @post = Post.find_by(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body)
    end

    # This is not the best way to do this, but let's keep it simple for this example
    def publish_to_social(post)
      tweet_it(post)
      share_it(post)
    end

    def notify_agencies(post)
      NotificationMailer.notification_email(post).deliver_later
    end

    def tweet_it(post)
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = 'YOUR_CONSUMER_KEY'
        config.consumer_secret     = 'YOUR_CONSUMER_SECRET'
        config.access_token        = 'YOUR_ACCESS_TOKEN'
        config.access_token_secret = 'YOUR_ACCESS_SECRET'
      end
      client.update(post.body)
    end

    def share_it(post)
      graph = Koala::Facebook::API.new('access_token')
      graph.put_wall_post(post.body)
    end
end
