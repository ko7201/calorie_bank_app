class Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    user = User.find_or_create_by!(email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
      user.build_profile(
        age: 30,
        height: 170,
        weight: 65,
        activity_level: 2,
        weight_to_lose: 5,
        gender: 1,
      )
    end
    sign_in user
    redirect_to user_root_path, notice: "ゲストユーザーとしてログインしました。"
  end
end
