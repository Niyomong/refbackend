class V1::NotificationsController < ApplicationController
  before_action :authenticate_v1_user!, only: [:index, :destroy]

  def index
    #current_userの投稿に紐づいた通知一覧（自分がvisitor & visited ではない場合のみ）
      notifications = current_v1_user.passive_notifications.where.not(visiter_id: current_v1_user.id).all

    #@notificationの中でまだ確認していない(indexに一度も遷移していない)通知のみ
      notifications.where(checked: false).each do |notification|
          notification.update_attributes(checked: true)
      end
      render json: { 
        status: 'SUCCESS', 
        data: notifications.as_json(include: [:visiter, :visited, :post, :comment]) 
      }
  end

  #通知を全削除はフロント側で設定
  def destroy
      notifications = current_v1_user.passive_notifications.destroy_all
      render json: { 
        status: 'SUCCESS', 
        message: 'Succefully deleted', 
        severity: 'success', 
        data: notifications 
      }
  end
  
end