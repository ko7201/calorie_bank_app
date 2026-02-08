class ProfilesController < ApplicationController
    def new
        @profile = Profile.new
    end

    def create
        @profile = Profile.new(profile_params)
        @profile.user = current_user
        if @profile.save
            redirect_to user_root_path, notice: "プロフィールが作成されました。"
        else
            render :new
        end
    end

    private
    def profile_params
        params.require(:profile).permit(:birth_date, :height, :weight, :activity_level, :weight_to_lose, :gender, :target_saving_calories)
    end
end
