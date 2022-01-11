class RenameTokenColumnToPosts < ActiveRecord::Migration[6.0]
  def change
    rename_column :posts, :token, :posttoken
  end
end
