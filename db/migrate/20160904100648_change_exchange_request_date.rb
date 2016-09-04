class ChangeExchangeRequestDate < ActiveRecord::Migration[5.0]
  def change
    change_column_default :exchanges, :request_date, nil
  end
end
