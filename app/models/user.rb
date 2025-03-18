class User < ApplicationRecord
  has_many :posts
  validates :name,{presence: true}
  validates :address,{presence: true, uniqueness: true}
end
