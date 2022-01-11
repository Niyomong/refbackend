class ChangeDataPostRefToPost < ActiveRecord::Migration[6.0]
  def change
    change_column :posts, :postRef, :text
  end
end
