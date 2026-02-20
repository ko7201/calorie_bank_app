class CalorieRecord < ApplicationRecord
  belongs_to :user
  before_validation :set_eat_date, on: :create

  enum meal_type: {
    breakfast: 0,
    lunch: 1,
    dinner: 2,
    snack: 3
    }

    scope :data_list, -> {
        order(eat_date: :asc, meal_type: :asc, created_at: :desc).limit(30)
      }

    scope :today, -> {
        where(eat_date: Date.current)
      }
    validates :calorie, presence: true,
            numericality: { only_integer: true, greater_than: 0 }

    validates :meal_type, presence: true

  private
  # 食事記録の日時は、記録が作成された日付をデフォルトとする
  def set_eat_date
    self.eat_date ||= Date.current
  end
end
