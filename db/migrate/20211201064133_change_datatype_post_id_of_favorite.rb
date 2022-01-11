class ChangeDatatypePostIdOfFavorite < ActiveRecord::Migration[6.0]
  def change
    change_column :favorites, :post_id, :string
  end
end
