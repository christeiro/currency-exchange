class CreateDailyRate < ActiveRecord::Migration[5.0]
  def change
    create_table :daily_rates do |t|
      t.date :rate_date
      t.float :rate
      t.timestamps
    end
    add_reference :daily_rates, :base_currency, references: :currencies, index: true
    add_reference :daily_rates, :target_currency, references: :currencies, index: true
  end
end
