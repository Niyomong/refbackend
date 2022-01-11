class RenameCountryColumnToPosts < ActiveRecord::Migration[6.0]
  def change
    rename_column :posts, :country, :postRef
  end
end
