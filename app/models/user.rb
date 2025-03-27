class User < ApplicationRecord
  has_many :lendings
  validates :name,{presence: true}
  validates :address,{presence: true, uniqueness: true}
end
