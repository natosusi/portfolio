class Lending < ApplicationRecord
  belongs_to :user
  belongs_to :book
  validates :schedule_date, presence: true

  #現在貸出中になっている貸出情報
  scope :currently_lendings, -> {where(returned_date: nil)}
end
