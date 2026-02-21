class Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    user = User.find_or_create_by!(email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
    end
    reset_guest_user_data!(user)
    sign_in user
    redirect_to after_sign_in_path_for(user), notice: "ゲストユーザーとしてログインしました。"
  end

  private

  def reset_guest_user_data!(user)
    user.calorie_records.destroy_all
    if user.profile
      user.profile.destroy
    end
  end
end
