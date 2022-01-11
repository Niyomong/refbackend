class RemoveDetailsFromNotifications < ActiveRecord::Migration[6.0]
  def change
    remove_column :notifications, :visiter_id_id, :integer
    remove_column :notifications, :visited_id_id, :integer
    remove_column :notifications, :post_id_id, :integer
    remove_column :notifications, :comment_id_id, :integer
  end
end
