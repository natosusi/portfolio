class CreateBooks < ActiveRecord::Migration[7.2]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.boolean :is_available, default: true, null: false

      t.timestamps
    end
  end
end
