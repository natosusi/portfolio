class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :lending
  validates :action_type, uniqueness: { scope: :lending }

  scope :unchecked, -> { where(checked: false) }
end
