# ログイン状態確認用コントローラー
class V1::Auth::SessionsController < ApplicationController

  def index
    if current_v1_user
      render json: { isLogin: true, data: current_v1_user }
    else
      render json: { isLogin: false, message: "ユーザーが存在しません" }
    end
  end

  def noticeCount
    if current_v1_user
      noticeCount = current_v1_user.passive_notifications.where.not(visiter_id: current_v1_user.id).count
      render json: { noticeCount: noticeCount }
    else
      render json: { isLogin: false, message: "ユーザーが存在しません" }
    end
  end


end
