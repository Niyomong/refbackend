class Bookmark < ApplicationRecord
  belongs_to :post, required: true
  belongs_to :user, required: true

  validates_uniqueness_of :post_id, scope: :user_id    # バリデーション（ユーザーと記事の組み合わせは一意）
  # 同じ投稿を複数回お気に入り登録させないため。
end
