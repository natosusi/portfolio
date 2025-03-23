class Book < ApplicationRecord
  has_many :loans

  def latest_loan
    #その本に関連するすべてのloanレコードを取得
    #取得したレコードを新しい順に並べ替え、そこから最新の1件を返す
    loans.order(created_at: :desc).first
  end
end
