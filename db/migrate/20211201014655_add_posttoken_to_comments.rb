class AddPosttokenToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :posttoken, :string
  end
end
