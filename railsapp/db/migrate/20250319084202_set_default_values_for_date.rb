class SetDefaultValuesForDate < ActiveRecord::Migration[7.2]
  def up
    Loan.update_all(borrowed_date: Date.current, schedule_date: Date.current, returned_date: Date.current)
  end

  def down
  end
end
