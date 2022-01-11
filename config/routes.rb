Rails.application.routes.draw do

  namespace :v1 do

    mount_devise_token_auth_for "User", at: "auth", controllers: {
      registrations: 'v1/auth/registrations',
    }
    namespace :auth do
      resources :sessions, only: %i[index] do
        get :noticeCount, on: :collection
      end
    end

    ###投稿###
    resources :posts do 
      # get 'search', on: :collection
      resources :likes, only: [:index, :create, :destroy] ### いいね機能 ###
      resources :bookmarks, only: [:create, :destroy] ### お気に入り機能 ###
      get :bookmarkStatus, on: :member
      get :likeStatus, on: :member

      resources :comments, only: [:index, :create, :destroy] ###コメント###
    end

    resources :comments, only: [:index, :create, :destroy]  do ###コメント###
      resources :comment_likes, only: [:create, :destroy] ### コメントいいね機能 ###
      get :commentLikeStatus, on: :member
    end

     ###ユーザー###
    resources :users, param: :name do
      get :followlist, on: :member
      get :followStatus, on: :member
      put :accountEdit, on: :member
      get :myBookmarks, on: :collection ### お気に入り機能 ###
      get :myUnpublishedPosts, on: :collection
      resource :relationships, only: [:create, :destroy]
    end

    resources :notifications, only: [:index, :destroy], param: :name  ### 通知機能 ###

    
  end #v1
end
