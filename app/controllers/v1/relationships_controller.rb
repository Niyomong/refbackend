class V1::RelationshipsController < ApplicationController
  before_action :set_followed_user, only: [:create, :destroy]

    def index
      followlist = Relationship.where(followed_id: current_v1_user).all
      render json: { status: 'SUCCESS', data: followlist }
    end


    def create
      unless @user.id == current_v1_user.id
        following = current_v1_user.follow(@user.id)
      end
      if following.save
        @user.create_notification_follow!(current_v1_user) #通知作成
        render json: { status: 'SUCCESS', message: 'Followed', data: following }
      else
        render json: { status: 'ERROR', message: 'Failed following', data: following.errors }
      end
    end

    def destroy
      unless @user.id == current_v1_user.id
        following = current_v1_user.unfollow(@user.id)
      end
      if following.destroy
        render json: { status: 'SUCCESS', message: 'Unfollow', data: following }
      else
        render json: { status: 'ERROR', message: 'Failed unfollow', data: following.errors }
      end
    end

    private
      def set_followed_user
        #routesでuserの中にrelationshipをネストしているため"user_name"
        @user = User.find_by(name: params[:user_name]) 
      end
  end
  