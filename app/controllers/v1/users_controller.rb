class V1::UsersController < ApplicationController
    before_action :authenticate_v1_user!, only: [:update, :destroy, :followStatus, :accountEdit, :myUnpublishedPosts]
    before_action :set_user, only: [:show, :update, :destroy, :followlist, :followStatus, :accountEdit]
    before_action :access_deny, only: [:update, :destroy]

    def index
      users = User.order(created_at: :desc)
      render json: { status: 'SUCCESS', message: 'Loaded users', data: users }
    end

    def show
      userPosts = Post.where(user: @user, published: true, question: false).order(created_at: :desc)
      userAsks = Post.where(user: @user, published: true, question: true).order(created_at: :desc)
      userComments = Comment.where(user_id: @user.id).order(created_at: :desc)
      userPrivatePosts = Post.where(user: @user, published: false, question: false).order(created_at: :desc)
      @followingCount = @user.followings.count
      @followerCount = @user.followers.count

      render json: { status: 'SUCCESS', message: 'Loaded myposts',
        userProfile: @user, 
        userPosts: userPosts.as_json(include: [:user, :comments, :likes, :bookmarks]), 
        userAsks: userAsks.as_json(include: [:user, :comments, :likes, :bookmarks]),
        userComments: userComments.as_json(include: [:post]),
        userPrivatePosts: userPrivatePosts.as_json(include: [:user, :comments]),
        userFollowingCount: @followingCount,
        userFollowerCount: @followerCount,
      }   
    end

    def followlist
      @followings = @user.followings #自分がフォローしているユーザー一覧
      @followers = @user.followers #自分をフォローしているユーザー一覧
      render json: 
        { status: 'SUCCESS', message: 'Loaded my followlists', 
          followings: @followings,    
          followers: @followers,
        }     
    end

    def followStatus
      followStatus = Relationship.where(follower_id: current_v1_user.id, followed_id: @user.id).exists?
      render json: { status: 'SUCCESS', message: 'isFollowing',  data: followStatus } 
    end

    def myBookmarks
      bookmarks = Bookmark.where(user_id: current_v1_user.id).pluck(:post_id)  # ログイン中のユーザーのお気に入りのpost_idカラムを取得
      bookmark_list = Post.find(bookmarks)     # postsテーブルから、お気に入り登録済みのレコードを取得 
      render json: { status: 'SUCCESS', message: 'Loaded the list of bookmarks', data: bookmark_list.as_json(include: [:user, :comments, :likes, :bookmarks]) }
    end
    
    def myUnpublishedPosts
      unPublishedPosts = Post.where(published: false, user_id: current_v1_user.id).order(created_at: :desc)
      render json: { status: 'SUCCESS', message: 'Loaded posts', data: unPublishedPosts.as_json(include: [:user, :comments]) }
    end

    def update
      userPosts = Post.where(user: @user, published: true, question: false).order(created_at: :desc)
      userAsks = Post.where(user: @user, published: true, question: true).order(created_at: :desc)
      userComments = Comment.where(user_id: @user.id).order(created_at: :desc)
      @followingCount = @user.followings.count
      @followerCount = @user.followers.count

      if @user.update(user_params)
          render json: { status: 'SUCCESS', message: 'Updated the user', severity: 'success',
            data: @user,
            userPosts: userPosts.as_json(include: [:user, :comments, :likes]), 
            userAsks: userAsks.as_json(include: [:user, :comments, :likes]),
            userComments: userComments.as_json(include: [:post]),
            userPrivatePosts: userPrivatePosts.as_json(include: [:user, :comments]),
            userFollowingCount: @followingCount,
            userFollowerCount: @followerCount,
          }
        else
          render json: { status: 'ERROR', message: 'Not updated', severity: 'error', data: @user.errors }
      end
    end
    
    def accountEdit
      if @user.update(image: params[:image])
        render json: { status: 'SUCCESS', message: 'Updated the user', severity: 'success', data: @user }
      else
        render json: { status: 'ERROR', message: 'Not updated', severity: 'error', data: @user.errors }
      end
    end

    def destroy
      if @user.destroy
        render json: { status: 'SUCCESS', message: 'アカウントを削除しました', data: @user }
      else
        render json: { status: 'ERROR', message: 'Failed', severity: 'error', data: @user.errors }
      end
    end
    
    private
        def user_params
          # params.require(:user).permit()
          params.permit(:id, :name, :email, :nickname, :image, :bio, :place, :website, :active, :provider, :uid, :allow_password_change)
        end
    
        def set_user
          # @user = User.find(params[:id])
          @user = User.find_by(name: params[:name]) #"id"ではなく"name"で受け取る
        end
    
        def access_deny
          if !(current_v1_user == @user)
            render json: { status: 'ERROR', message: 'Not Authenticated', data: @user.errors }
          end
        end
    
    end
    
