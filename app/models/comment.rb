require 'securerandom'

class Comment < ApplicationRecord
  before_create :set_random_comment_id

  belongs_to :user, required: true
  belongs_to :post, required: false
  has_many :commentLikes, dependent: :destroy #いいね機能
  has_many :notifications, dependent: :destroy #通知機能

  validates :commentContent, length: { maximum: 1000 }


### likeされたら通知 ###
def create_notification_commentlike!(current_v1_user)
  # すでに「いいね」されているか検索
  liked = Notification.where(visiter_id: current_v1_user.id, visited_id: user_id, comment_id: id, action: 'commentLike')
  # いいねされていない場合のみ、通知レコードを作成
  if liked.blank?
    notification = current_v1_user.active_notifications.new(comment_id: id, visited_id: user_id, action: 'commentLike')
    # 自分の投稿に対するいいねの場合は、通知済みとする
    if notification.visiter_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end


  private
  def set_random_comment_id
    # id未設定、または、すでに同じidのレコードが存在する場合はループに入る
    while self.id.blank? || Comment.find_by(id: self.id).present? do
      # ランダムな20文字をidに設定し、whileの条件検証に戻る
      self.id = SecureRandom.alphanumeric(20)
    end
  end

end
