class HomesController < ApplicationController
    before_action :authenticate_user!

    def index
        @calorie_records = current_user.calorie_records.data_list
    end
end
