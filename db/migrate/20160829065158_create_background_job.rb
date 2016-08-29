class CreateBackgroundJob < ActiveRecord::Migration[5.0]
  def change
    create_table :background_jobs do |t|
      t.date :start_date, null: false, default: Date.today
      t.integer :period
      t.integer :completed, length: 1
    end
    add_reference :background_jobs, :base_currency, references: :currencies, index: true
    add_reference :background_jobs, :target_currency, references: :currencies, index: true
    add_reference :background_jobs, :exchange
  end
end
