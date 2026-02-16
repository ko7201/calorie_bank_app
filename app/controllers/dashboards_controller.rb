class DashboardsController < ApplicationController
  before_action :authenticate_user!

  MEALS = {
    "朝食" => :breakfast,
    "昼食" => :lunch,
    "夕食" => :dinner,
    "おやつ" => :snack
  }.freeze

  def index
    @meals = MEALS

    records = current_user.calorie_records.where(eat_date: Date.current)
    @calorie_records = records.index_by(&:meal_type)  # "breakfast" 等（文字列）

    @record = @meals.values.index_with do |meal_type|
      @calorie_records[meal_type.to_s] || current_user.calorie_records.new(meal_type: meal_type)
    end
  end
end
