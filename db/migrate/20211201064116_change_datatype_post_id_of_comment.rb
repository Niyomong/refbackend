class ChangeDatatypePostIdOfComment < ActiveRecord::Migration[6.0]
  def change
    change_column :comments, :post_id, :string
  end
end