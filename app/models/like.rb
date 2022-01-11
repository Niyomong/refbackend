class Like < ApplicationRecord
  belongs_to :post, required: true
  belongs_to :user, required: true

  validates_uniqueness_of :post_id, scope: :user_id
end
