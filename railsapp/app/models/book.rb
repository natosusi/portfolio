class Book < ApplicationRecord
  has_many :lendings
  has_many :reviews
  has_many :likes
  validates :title, presence: true
  validates :author, presence: true
  validates :description, presence: true
  validates :image_link, presence: true

  def latest_lending
    lendings.last
  end
end
