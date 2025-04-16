class RenameLoansToLendings < ActiveRecord::Migration[7.2]
  def change 
    rename_table :loans, :lendings
  end
end
