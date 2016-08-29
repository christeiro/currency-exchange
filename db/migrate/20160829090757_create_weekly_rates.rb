class CreateWeeklyRates < ActiveRecord::Migration[5.0]
  def change
    create_table :weekly_rates do |t|
      t.date :rate_date
      t.float :rate
      t.timestamps
    end
    add_reference :weekly_rates, :base_currency, references: :currencies, index: true
    add_reference :weekly_rates, :target_currency, references: :currencies, index: true
  end
end
