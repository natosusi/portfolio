class Lending < ApplicationRecord
  belongs_to :user
  belongs_to :book
  has_many :notification, dependent: :destroy
  validates :schedule_date, presence: true

  #現在貸出中になっている貸出情報
  scope :currently_lendings, -> {where(returned_date: nil)}

  #貸出中から当日期限のものを取り出す
  def self.due_date(sign_in_user)
    if sign_in_user.lendings.present?
      Lending.where(user_id: sign_in_user, returned_date: nil, schedule_date: Date.current)
    end
  end
end
