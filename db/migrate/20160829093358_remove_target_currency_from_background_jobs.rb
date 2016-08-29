class RemoveTargetCurrencyFromBackgroundJobs < ActiveRecord::Migration[5.0]
  def change
    remove_reference :background_jobs, :target_currency
  end
end
