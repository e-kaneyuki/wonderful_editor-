class Api::V1::BaseApiController < ApplicationController
  # def current_user
  #   @current_user ||= User.first
  # end
  alias_method :current_user, :current_api_v1_user
  # #ログインしていないと使えない API は authenticate_user! で弾くように実装しよう。
  alias_method :authenticate_user!, :authenticate_api_v1_user!

  alias_method :user_signed_in?, :api_v1_user_signed_in?
end
