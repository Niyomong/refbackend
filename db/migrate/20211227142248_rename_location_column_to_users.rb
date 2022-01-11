class RenameLocationColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :location, :place
  end
end
