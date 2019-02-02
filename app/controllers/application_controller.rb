# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protected

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to User.superadmin.exists? ? login_path : first_setup_path
    end
  end

  def authenticate_api!
    @current_user ||= User.where(api_token: params[:token]).first if params.key?(:token)
    render json: { errors: ['Invalid api token!'] } unless user_signed_in? || @current_user
  end
end
