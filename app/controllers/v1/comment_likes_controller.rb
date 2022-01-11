class V1::CommentLikesController < ApplicationController
  before_action :authenticate_v1_user!, only: [:create, :destroy]

  def create
    commentlike = CommentLike.new(user_id: current_v1_user.id, comment_id: params[:comment_id])
    commentlike.save

    comment = Comment.find(params[:comment_id])
    comment.create_notification_commentlike!(current_v1_user) #commentいいね通知の作成

    if commentlike.save
      render json: { status: 'SUCCESS', message: 'Liked a comment', commentLikeStatus: true }
    else
      render json: { status: 'ERROR', message: 'Failed like', data: like.errors }
    end
  end

  def destroy
    commentlike = CommentLike.find(params[:id])
    commentlike.destroy
    if commentlike.destroy
      render json: { status: 'SUCCESS', message: 'Disliked a comment', commentLikeStatus: false }
    else
      render json: { status: 'ERROR', message: 'Failed dislike', data: commentlike.errors }
    end
  end




end
