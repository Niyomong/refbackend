class ChangeDatatypeCommentIdOfNotification < ActiveRecord::Migration[6.0]
  def change
    change_column :notifications, :comment_id, :string
  end
end
