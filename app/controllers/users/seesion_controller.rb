class Users::SessionsController < Devise::SessionsController
　# ゲストログイン用コントローラー

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to user_path(user), notice: "guestuserでログインしました。"
  end
end