class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern unless Rails.env.test?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_header_stats, if: :user_signed_in?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end

  #ログイン後の遷移先
  def after_sign_in_path_for(resource)
    return new_profile_path unless resource.profile.present?
    user_root_path
  end


  private

  def set_header_stats
    @today_total = current_user.calorie_records.today.sum(:calorie)

    profile = current_user.profile
    unless profile
      @calorie_goal = 0
      @bmr = 0
      @calorie_saved = 0
      return
    end
    
    @calorie_goal = current_user.profile.target_saving_calories
    @bmr = current_user.profile.bmr.round
    @calorie_saved = [@bmr - @today_total, 0].max
  end
end
