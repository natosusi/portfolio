class Lending < ApplicationRecord
  belongs_to :user
  belongs_to :book

  #現在貸出中になっている貸出情報
  scope :currently_lendings, -> {where(returned_date: nil)}
  #ユーザーidで貸出情報を絞り込む
  scope :users_lendings, ->(user_id) {where(user_id: user_id).order(id: "DESC")}
end
