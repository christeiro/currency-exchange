class DropBacgroundJobsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :background_jobs do |t|
      t.date :start_date, null: false, default: Date.today
      t.integer :period
      t.integer :completed, length: 1
    end
  end
end
