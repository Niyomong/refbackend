class ChangeDatatypePostIdOfNotification < ActiveRecord::Migration[6.0]
  def change
    change_column :notifications, :post_id, :string
  end
end
