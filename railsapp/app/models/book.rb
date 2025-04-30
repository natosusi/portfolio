class Book < ApplicationRecord
  has_many :lendings
  has_many :reviews

  def latest_lending
    #その本に関連するすべてのloanレコードを取得
    #取得したレコードを新しい順に並べ替え、そこから最新の1件を返す
    lendings.order(created_at: :desc).first
  end
end
