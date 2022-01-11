class CreateCommentLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :comment_likes do |t|
      t.string :user_id, null: false, foreign_key: true
      t.string :comment_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
