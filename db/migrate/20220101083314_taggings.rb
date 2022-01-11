class Taggings < ActiveRecord::Migration[6.0]
  def change
    drop_table :taggings
  end
end
