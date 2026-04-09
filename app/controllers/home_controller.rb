class HomeController < ApplicationController
    before_action :authenticate_user!

    def index
        records = current_user.calorie_records.where(eat_date: Date.current)
        @calorie_records = records.index_by { |record| record.meal_type }
    end
end
