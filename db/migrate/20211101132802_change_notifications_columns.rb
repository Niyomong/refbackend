class ChangeNotificationsColumns < ActiveRecord::Migration[6.0]
  def change
    # remove_column :notifications, :visiter_id, :references
    # remove_column :notifications, :visited_id, :references
    # remove_column :notifications, :post_id, :references
    # remove_column :notifications, :comment_id, :references

    add_column :notifications, :visiter_id, :integer
    add_column :notifications, :visited_id, :integer
    add_column :notifications, :post_id, :integer
    add_column :notifications, :comment_id, :integer
  end
end
