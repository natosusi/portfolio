class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :lending
  validates :action_type, presence: true, uniqueness: { scope: :lending }
  validates :checked, inclusion: { in: [true, false] }

  scope :unchecked, -> { where(checked: false) }
end
