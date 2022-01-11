class RenamePostFavorites < ActiveRecord::Migration[6.0]
  def change
    rename_column :favorites, :post_id, :posttoken
  end
end
