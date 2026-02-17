class CalorieRecordsController < ApplicationController
  before_action :authenticate_user!

  def create
    record = current_user.calorie_records.find_or_initialize_by(
      eat_date: Date.current,
      meal_type: calorie_record_params[:meal_type]
    )

    if record.update(calorie_record_params)
      redirect_to user_root_path, notice: "保存しました"
    else
      redirect_to user_root_path, alert: "失敗しました"
    end
  end

  private
  def calorie_record_params
    params.require(:calorie_record).permit(:calorie, :meal_type, :memo)
  end
end
