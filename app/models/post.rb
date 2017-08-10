class Post < ApplicationRecord
  validates :body,
            presence: { message: '001' },
            length: { minimum: 10, message: '002' }
end
