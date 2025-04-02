class RemoveAgeFromUsers < ActiveRecord::Migration[7.2]
  def change
    remove_column :users, :age, :integer
  end
end
