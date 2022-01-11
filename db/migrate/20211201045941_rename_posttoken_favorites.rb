class RenamePosttokenFavorites < ActiveRecord::Migration[6.0]
  def change
    rename_column :favorites, :posttoken, :post_id
  end
end
