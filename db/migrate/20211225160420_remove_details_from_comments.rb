class RemoveDetailsFromComments < ActiveRecord::Migration[6.0]
  def change
    remove_column :comments, :isAnswer, :boolean
    remove_column :comments, :commenttoken, :string
    remove_column :comments, :posttoken, :string
  end
end
