class RemoveBorrowedDateFromLendings < ActiveRecord::Migration[7.2]
  def change
    remove_column :lendings, :borrowed_date, :date
  end
end
