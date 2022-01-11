class V1::LikesController < ApplicationController
  before_action :authenticate_v1_user!, only: [:create, :destroy]

  def index
    likes = Like.where(post_id: params[:post_id]).all
    render json: { status: 'SUCCESS', message: 'Likes List', data: likes }
  end

  def create
    like = Like.new(user_id: current_v1_user.id, post_id: params[:post_id])
    like.save

    post = Post.find(params[:post_id])
    post.create_notification_like!(current_v1_user) #いいね通知の作成

    if like.save
      render json: { status: 'SUCCESS', message: 'Liked a post', likeStatus: true }
    else
      render json: { status: 'ERROR', message: 'Failed like', data: like.errors }
    end
  end

  def destroy
    like = Like.find(params[:id])
    like.destroy
    if like.destroy
      render json: { status: 'SUCCESS', message: 'Disliked a post', likeStatus: false }
    else
      render json: { status: 'ERROR', message: 'Failed dislike', data: like.errors }
    end
  end
end