class ChangeDatatypePostIdOfLike < ActiveRecord::Migration[6.0]
  def change
    change_column :likes, :post_id, :string
  end
end
