class RenameFollowIdColumnToRelationships < ActiveRecord::Migration[6.0]
  def change
    rename_column :relationships, :user_id, :followed_id
    rename_column :relationships, :follow_id, :follower_id
  end
end

