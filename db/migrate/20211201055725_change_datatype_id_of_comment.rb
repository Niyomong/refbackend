class ChangeDatatypeIdOfComment < ActiveRecord::Migration[6.0]
  def change
    change_column :comments, :id, :string
  end
end
