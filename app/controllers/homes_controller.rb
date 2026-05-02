class HomesController < ApplicationController
    before_action :authenticate_user!

      MEALS = {
    "朝食" => :breakfast,
    "昼食" => :lunch,
    "夕食" => :dinner,
    "おやつ" => :snack
  }.freeze

    def index
        @meals = MEALS
        @calorie_records = current_user.calorie_records.today_total
        set_home_stats
        set_total_saved_calorie
    end

    private

  def set_home_stats
    @today_total = current_user.calorie_records.today.sum(:calorie)
    # プロフィール情報がない場合は0を表示する
    profile = current_user.profile
    unless profile
      @calorie_goal = 0
      @bmr = 0
      @calorie_saved = 0
      return
    end

    @calorie_goal = current_user.profile.target_saving_calories
    @bmr = current_user.profile.bmr.round
    @calorie_saved = [ @bmr - @today_total, 0 ].max
    @rice_kcal_per_bowl = current_user.profile.rice_kcal_per_bowl
  end

  def set_total_saved_calorie
    records_by_date = current_user.calorie_records.group_by do |record|
      record.eat_date
    end

    total = 0

    records_by_date.each do |_date, records|
      daily_intake = 0

      records.each do |record|
        daily_intake += record.calorie
      end

      daily_saved = @bmr - daily_intake

      total += daily_saved
    end

    @total_saved_calorie = total
  end
end
