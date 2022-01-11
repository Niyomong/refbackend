class Notification < ApplicationRecord

  #スコープ(新着順)
  default_scope->{order(created_at: :desc)}

  ## optional: true => nilを許容
  belongs_to :post, optional: true
  belongs_to :comment, optional: true
  belongs_to :visiter, class_name: 'User', foreign_key: 'visiter_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true

end

# visiter_id : 通知を送ったユーザーのid
# visited_id : 通知を送られたユーザーのid
# post_id : いいねされた投稿のid
# comment_id : 投稿へのコメントのid
# action : 通知の種類（フォロー、いいね、コメント）
# checked : 通知を送られたユーザーが通知を確認したかどうか