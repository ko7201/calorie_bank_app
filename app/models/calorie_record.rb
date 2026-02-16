class CalorieRecord < ApplicationRecord
  belongs_to :user

  enum record_type: {
    breakfast: 0,
    lunch: 1,
    dinner: 2,
    snack: 3,
    }
end
