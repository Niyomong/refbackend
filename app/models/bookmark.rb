class Bookmark < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates_uniqueness_of :post_id, scope: :user_id    # バリデーション（ユーザーと記事の組み合わせは一意）
  # 同じ投稿を複数回お気に入り登録させないため。
end
