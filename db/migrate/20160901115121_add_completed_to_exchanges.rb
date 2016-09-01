class AddCompletedToExchanges < ActiveRecord::Migration[5.0]
  def change
    add_column :exchanges, :completed, :integer, length: 1, default: 0
  end
end
