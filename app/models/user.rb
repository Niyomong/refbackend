# frozen_string_literal: true

class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User


  validates :name,
            uniqueness: true,
            format: { with: /\A[a-zA-Z\d]+\z/, message: "半角英数字のみ利用可能です。" },
            length: { minimum: 3, maximum: 25 }
  def to_param
    return self.name
  end

  validates :bio, length: { maximum: 200 }
  validates :place, length: { maximum: 50 }
  validates :website, length: { maximum: 100 }

  #カラムの名前をmount_uploaderに指定(carrierwave)
  mount_uploader :image, ImageUploader

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  # いいね機能
  has_many :likes, dependent: :destroy
  has_many :commentLikes, dependent: :destroy

  #フォロー機能
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower # 被フォロー関係を通じて参照→followed_idをフォローしている人
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy #【class_name: "Relationship"】は省略可能
  has_many :followings, through: :relationships, source: :followed #与フォロー関係を通じて参照→follower_idをフォローしている人
 #（参考） foregin_key = 入口、source = 出口
 
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

############ 通知機能（フォロー時） ############
#自分からの通知  
has_many :active_notifications, class_name: "Notification", foreign_key: "visiter_id", dependent: :destroy
#相手からの通知
has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy


  def create_notification_follow!(current_v1_user)
    temp = Notification.where(visiter_id: current_v1_user.id, visited_id: id, action: 'follow')
    if temp.blank?
      notification = current_v1_user.active_notifications.new(visited_id: id, action: 'follow')
      notification.save if notification.valid?
    end
  end


end
