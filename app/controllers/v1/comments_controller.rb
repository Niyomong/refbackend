class V1::CommentsController < ApplicationController
    before_action :authenticate_v1_user!, only: [:create, :destroy]
    before_action :set_comment, only: [:destroy, :commentLikeStatus]
    before_action :access_deny, only: [:destroy]

    def index
      comments = Comment.order(created_at: :desc).where(post_id: (params[:post_id])).all
      render json: { status: 'SUCCESS', message: 'Loaded comments', data: comments.as_json(include: [:user, :commentLikes])}
    end

    def commentLikeStatus
      if v1_user_signed_in?
        commentLikeStatus = CommentLike.where(user_id: current_v1_user.id, comment_id: @comment).exists?
        if commentLikeStatus == true then
          commentLikeId = CommentLike.where(user_id: current_v1_user.id, comment_id: @comment)[0].id
          render json: { status: 'SUCCESS', message: 'Loaded commentLikeStatus', commentLikeStatus: commentLikeStatus, commentLikeId: commentLikeId }
        else
          render json: { status: 'SUCCESS', message: 'Loaded commentLikeStatus', commentLikeStatus: commentLikeStatus }
        end  
      else
        commentLikeStatus = false
        render json: { status: 'SUCCESS', message: 'Loaded commentLikeStatus', commentLikeStatus: commentLikeStatus, commentLikeId: commentLikeId }
      end
    end

    def create
      post = Post.find(params[:post_id]) #通知作成用
      comment = Comment.new(comment_params)
      comment.post = Post.find(params[:post_id])
      comment.user = current_v1_user
      comment_item = comment.post

      if comment.save
        comment_item.create_notification_comment!(current_v1_user, comment.id) #コメント通知の作成

        render json: { status: 'SUCCESS', message: 'sucessfully commented', data: comment }
      else
        render json: { status: 'ERROR', data: comment.errors }
      end
    end
  
    def destroy
      # @comment = Comment.find(params[:id])
      @comment.destroy
      render json: { status: 'SUCCESS', message: 'Deleted the comment', data: @comment }
    end

    private

      def set_comment
        @comment = Comment.find(params[:id])
      end

      def comment_params
        params.permit(:user_id, :post_id, :commentContent)
      end
  
      def access_deny
        if !(current_v1_user == @comment.user)
          render json: { status: 'ERROR', message: 'Not Authenticated', data: @comment.errors }
        end
      end

  end
  