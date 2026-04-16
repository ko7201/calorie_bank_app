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
    end
end
