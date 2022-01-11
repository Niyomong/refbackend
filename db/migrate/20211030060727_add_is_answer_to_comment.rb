class AddIsAnswerToComment < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :isAnswer, :boolean, default: false
  end
end
