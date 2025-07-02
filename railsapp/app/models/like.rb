class Like < ApplicationRecord
  belongs_to :book
  belongs_to :user
  validates :user_id, uniqueness: { scope: :book_id }

  def self.liked_by?(book, user)
    exists?(book_id: book.id, user_id: user.id)
  end
  scope :currently_likes, ->(book_id) {where(book_id: book_id)}
end
