class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts, id: :string do |t|
      t.references :user, null: false, foreign_key: true
      t.text :postContent
      t.boolean :published, null: false, default: false
      t.boolean :question, null: false, default: false
      t.string :country

      t.timestamps
    end
  end
end
