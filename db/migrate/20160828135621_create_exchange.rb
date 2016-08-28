class CreateExchange < ActiveRecord::Migration[5.0]
  def change
    create_table :exchanges do |t|
      t.integer :amount
      t.integer :period
      t.date :request_date, null: false, default: Date.today
    end
    add_reference :exchanges, :user, index: true
    add_reference :exchanges, :base_currency, references: :currencies, index: true
    add_reference :exchanges, :target_currency, references: :currencies, index: true
  end
end
