class AddColumnToBooks < ActiveRecord::Migration[7.2]
  def change
    add_column :books, :author, :string
    add_column :books, :description, :text
    add_column :books, :image_link, :string
  end
end
