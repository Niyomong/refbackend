require 'securerandom'

class Post < ApplicationRecord
  before_create :set_random_post_id
  validates :postContent, length: { maximum: 1000 }

  belongs_to :user, required: true
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :likes, dependent: :destroy #いいね機能

# 検索機能
  def self.search(search)
    if search
      Post.where('postContent LIKE(?)', "%#{search}%")
    else
      Post.all
    end
  end


############ 通知機能（like、comment(質問への回答orコメント)） ############
has_many :notifications, dependent: :destroy #通知機能

### likeされたら通知 ###
def create_notification_like!(current_v1_user)
    # すでに「いいね」されているか検索
    liked = Notification.where(visiter_id: current_v1_user.id, visited_id: user_id, post_id: id, action: 'like')
    # いいねされていない場合のみ、通知レコードを作成
    if liked.blank?
      notification = current_v1_user.active_notifications.new(post_id: id, visited_id: user_id, action: 'like')
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visiter_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
end

### コメントされたら通知 ###
def create_notification_comment!(current_v1_user, comment_id)
  # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
  temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_v1_user.id).distinct #distinct:重複レコードを1つにまとめる
  temp_ids.each do |temp_id|
      save_notification_comment!(current_v1_user, comment_id, temp_id['user_id'])
  end
  # まだ誰もコメントしていない場合は、投稿者に通知を送る
  save_notification_comment!(current_v1_user, comment_id, user_id) if temp_ids.blank?
end
def save_notification_comment!(current_v1_user, comment_id, visited_id)
  # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
  notification = current_v1_user.active_notifications.new(post_id: id, comment_id: comment_id, visited_id: visited_id, action: 'comment')
  # 自分の投稿に対するコメントの場合は、通知済みとする
  if notification.visiter_id == notification.visited_id
    notification.checked = true
  end
  notification.save if notification.valid?
end
################################


private
  def set_random_post_id
    # self.id = SecureRandom.urlsafe_base64
    # id未設定、または、すでに同じidのレコードが存在する場合はループに入る
    while self.id.blank? || Post.find_by(id: self.id).present? do
      # ランダムな20文字をidに設定し、whileの条件検証に戻る
      self.id = SecureRandom.alphanumeric(20)
    end
  end

end
