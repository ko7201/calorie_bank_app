class CalorieRecordsController < ApplicationController
  before_action :authenticate_user!

  def create
    calorie_record = current_user.calorie_records.new(calorie_record_params)
    if calorie_record.save
      redirect_to user_root_path, notice: "カロリー記録が保存されました。"
    else
      redirect_to user_root_path, alert: "カロリー記録の保存に失敗しました。"
    end
  end

  private
  def calorie_record_params
    params.require(:calorie_record).permit(:calorie, :meal_type, :memo)
  end

end
