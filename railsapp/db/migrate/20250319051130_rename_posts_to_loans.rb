class RenamePostsToLoans < ActiveRecord::Migration[7.2]
  def change
    #rename_table :posts, :loans
    #remove_column :loans, :title, :string
    #remove_column :loans, :content, :text

    change_table :loans do |t|
      #Booksテーブルへの紐付け
      #t.references :book, null: false, foreign_key: true
      #貸し出し日
      t.date :borrowed_date, null: true
      #返却予定日
      t.date :schedule_date, null: true
      #返却日
      t.date :returned_date, null: true
      #t.timestamps
    end
  end
end
