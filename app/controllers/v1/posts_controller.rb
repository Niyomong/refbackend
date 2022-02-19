class V1::PostsController < ApplicationController
    before_action :authenticate_v1_user!, only: [:new, :edit, :update, :destroy]
    before_action :set_post, only: [:bookmarkStatus, :likeStatus, :show, :update, :destroy]
    before_action :access_deny, only: [:update, :destroy] #authenticate_userならどのPOSTでも編集削除できてしまうため

    include Pagination

    def index

      if params[:keyword]
          keywords = params[:keyword].split(/[[:blank:]]+/).select(&:present?)
          @posts = Post
          keywords.each do |keyword|
            @posts = @posts.where(['postContent LIKE (?) OR postRef LIKE (?) OR postLink LIKE (?)', "%#{keyword}%", "%#{keyword}%", "%#{keyword}%"])
          end
          posts = @posts.where(published: true)
            .limit(50)
            .page(params[:page]).per(5)
            .where(:created_at=>6.months.ago..Time.now)
            .order(created_at: :desc)
      else
          posts = Post.where(published: true)
            .limit(50)
            .page(params[:page]).per(5)
            .where(:created_at=>6.months.ago..Time.now)
            .order(created_at: :desc)
      end

      @pagination = pagination(posts)

      render json: { status: 'SUCCESS', message: 'Loaded posts', 
        data: posts.as_json(include: [:user, :comments, :likes, :bookmarks]), 
        pagination: @pagination,
      }
    end


    def show
      likeCount = @post.likes.count
      commentCount = @post.comments.count
      bookmarkCount = @post.bookmarks.count
        render json: { status: 'SUCCESS', message: 'Loaded the post', 
          data: @post.as_json(include: [:user, :comments]), 
          likeCount: likeCount, 
          commentCount: commentCount, 
          bookmarkCount: bookmarkCount,
        }
    end

    def bookmarkStatus
      if v1_user_signed_in?
        bookmark = Bookmark.where(user_id: current_v1_user, post_id: @post).exists?
      else
        bookmark = false
      end
      render json: { status: 'SUCCESS', message: 'Loaded bookmarkStatus', data: bookmark } 
    end


    def create
      post = Post.new(post_params)
      post.user = current_v1_user

      if post.save
        render json: { status: 'SUCCESS', message: '投稿しました', data: post.as_json(include: [:user, :comments]) }
      else
        render json: { status: 'ERROR', message: '投稿に失敗しました', data: post.errors }
      end
    end

    def destroy
      @post.destroy
      render json: { status: 'SUCCESS', message: '投稿を削除しました' }
    end

    def update
      if @post.update(post_params)
        render json: { status: 'SUCCESS', message: '更新しました', data: @post.as_json(include: [:user, :comments]) }
      else
        render json: { status: 'ERROR', message: '更新に失敗しました', data: @post.errors }
      end
    end

    def bookmarkStatus
      if v1_user_signed_in?
        bookmark = Bookmark.where(user_id: current_v1_user, post_id: @post).exists?
      else
        bookmark = false
      end
      render json: { status: 'SUCCESS', message: 'Loaded bookmarkStatus', data: bookmark } 
    end

    def likeStatus
      if v1_user_signed_in?
        likeStatus = Like.where(user_id: current_v1_user.id, post_id: @post).exists?
        if likeStatus == true then
          likeId = Like.where(user_id: current_v1_user.id, post_id: @post)[0].id
          render json: { status: 'SUCCESS', message: 'Loaded likeStatus', likeStatus: likeStatus, likeId: likeId }
        else
          render json: { status: 'SUCCESS', message: 'Loaded likeStatus', likeStatus: likeStatus }
        end  
      else
        likeStatus = false
        render json: { status: 'SUCCESS', message: 'Loaded likeStatus', likeStatus: likeStatus, likeId: likeId }
      end
    end

    private
      def set_post
        @post = Post.find(params[:id])
      end

      def post_params
        # params.require(:post).permit
        params.permit(:user, :postContent, :postRef, :postLink, :question, :published, :comments, :created_at, :updated_at)
      end

      def access_deny
        if !(current_v1_user == @post.user)
          render json: { status: 'ERROR', message: 'Not Authenticated', data: @post.errors }
        end
      end

end
