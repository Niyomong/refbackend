class V1::BookmarksController < ApplicationController
  before_action :authenticate_v1_user!, only: [:create, :destroy]
  before_action :set_post, only: [:create, :destroy]

  # お気に入り登録
  def create
    if @post.user_id != current_v1_user.id   # 投稿者本人以外に限定
      @bookmark = Bookmark.create(user_id: current_v1_user.id, post_id: @post.id)
      render json: { status: 'SUCCESS', data: @bookmark }
    else
      render json: { status: 'ERROR', message: '自分の投稿はBOOKMARKできません', data: @post.errors }
    end
  end

  # お気に入り削除
  def destroy
    @bookmark = Bookmark.find_by(user_id: current_v1_user.id, post_id: @post)
    @bookmark.destroy
    render json: { status: 'SUCCESS', message: 'Deleted from bookmarks', data: @bookmark }
  end

  private
  def set_post
    @post = Post.find(params[:post_id])
  end
end
