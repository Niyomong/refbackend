class CreateRefs < ActiveRecord::Migration[6.0]
  def change
    create_table :refs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.text :refContent

      t.timestamps
    end
  end
end
