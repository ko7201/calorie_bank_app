class HomesController < ApplicationController
    before_action :authenticate_user!

    def index
        @calorie_records = current_user.calorie_records.today_total
    end
end
