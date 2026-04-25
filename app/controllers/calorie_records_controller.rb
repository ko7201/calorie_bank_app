class CalorieRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_calorie_record, only: %i[update]
  def index
    @calorie_records = current_user.calorie_records.data_list
  end

  def new
    @meal_type = params[:meal_type]
    @calorie_record = CalorieRecord.new
  end

  def liff_new
    @meal_type = params[:meal_type]
    @calorie_record = CalorieRecord.new
    render :new
  end
  
  def create
    record = current_user.calorie_records.find_or_initialize_by(
      eat_date: Date.current,
      meal_type: calorie_record_params[:meal_type]
    )

    if record.update(calorie_record_params)
      if record.image.present?
        new_calorie = GeminiService.call(record)
        if new_calorie
          record.update(base_calorie: new_calorie)
          redirect_to user_root_path, notice: "カロリーを推定しました（#{new_calorie} kcal）"
        else
          redirect_to user_root_path, alert: "カロリーの推定に失敗しました。再度時間を空けてお試しください。"
        end
      else
        redirect_to user_root_path, notice: "保存しました"
      end
    else
      redirect_to user_root_path, alert: "失敗しました"
    end
  end

  def update
    if @calorie_record.update(calorie_record_params)
      redirect_to user_root_path, notice: "更新しました"
    else
      redirect_to user_root_path, alert: "失敗しました"
    end
  end


  private

  def calorie_record_params
    params.require(:calorie_record).permit(:base_calorie, :meal_type, :memo, :rice_bowls, :image)
  end

  def set_calorie_record
    @calorie_record = current_user.calorie_records.find(params[:id])
  end
end
