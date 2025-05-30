class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user 
  validates :title, presence: true
  validates :comment, presence: true
end
