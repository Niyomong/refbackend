class RenamePosttokenColumnToPosts < ActiveRecord::Migration[6.0]
  def change
    rename_column :posts, :posttoken, :postLink
  end
end
