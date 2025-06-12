class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :lending
  validates :action_type,{ presence: true, uniqueness: { scope: :lending }, length: { in: 1..3 } }

  scope :not_returned, -> { joins(:lending).merge(Lending.currently_lendings) }
end
