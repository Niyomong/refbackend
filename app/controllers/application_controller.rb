# class ApplicationController < ActionController::API
class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
    skip_before_action :verify_authenticity_token # APIではCSRFチェックをしない
    helper_method :current_v1_user, :v1_user_signed_in?
end
