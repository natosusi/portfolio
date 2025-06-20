class Lending < ApplicationRecord
  belongs_to :user
  belongs_to :book
  has_many :notification, dependent: :destroy
  validates :schedule_date, presence: true

  scope :currently_lendings, -> {where(returned_date: nil)}

  scope :due_date, -> {where(returned_date: nil).where(schedule_date: Date.current)} 
  
  scope :is_the_day_before_due, -> {where(returned_date: nil).where(schedule_date: Date.current.tomorrow)}
end
