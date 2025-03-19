class User < ApplicationRecord
  has_many :loans
  validates :name,{presence: true}
  validates :address,{presence: true, uniqueness: true}
end
