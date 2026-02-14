class ProfilesController < ApplicationController
    before_action :authenticate_user!
    # プロフィールの重複作成を防ぐ
    before_action :redirect_if_profile_exists, only: [:new, :create]
    before_action :hide_nav, only: [:new, :create]

    def new
        @profile = Profile.new
    end

    def create
        @profile = current_user.build_profile(profile_params)
        if @profile.save
            redirect_to user_root_path, notice: "プロフィールが作成されました。"
        else
            render :new
        end
    end

    private
    # プロフィールの重複作成を防ぐためのリダイレクト
    def redirect_if_profile_exists
        redirect_to edit_profile_path(current_user.profile) if current_user.profile.present?
    end

    def profile_params
        params.require(:profile).permit(:birth_date, :height, :weight, :activity_level, :weight_to_lose, :gender, :target_saving_calories)
    end

    def hide_nav
        @hide_nav = true
    end 
end
