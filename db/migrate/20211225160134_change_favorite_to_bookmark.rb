class ChangeFavoriteToBookmark < ActiveRecord::Migration[6.0]
  def change
    rename_table :favorites, :bookmarks
  end
end
