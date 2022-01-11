class ChangeDataPostLinkToPost < ActiveRecord::Migration[6.0]
  def change
    change_column :posts, :postLink, :text
  end
end
