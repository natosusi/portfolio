class RemoveIsAvailableFromBooks < ActiveRecord::Migration[7.2]
  def change
    remove_column :books, :is_available, :boolean
  end
end
