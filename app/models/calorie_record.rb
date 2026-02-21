class CalorieRecord < ApplicationRecord
  belongs_to :user
  before_validation :set_eat_date, on: :create
  before_validation :set_rice_kcal_per_bowl, on: %i[create update]
  before_validation :calculate_total_calories, on: %i[create update]

  enum :meal_type, {
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
    validates :rice_bowls,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
    validates :base_calorie, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  private
  # 食事記録の日時は、記録が作成された日付をデフォルトとする
  def set_eat_date
    self.eat_date ||= Date.current
  end
  # 記録作成時に、その時点のご飯１杯あたりのカロリーを保存する
  # （プロフィール変更によって過去の記録が変わらないようにするため
  def set_rice_kcal_per_bowl
    self.rice_bowls = rice_bowls.to_i

    if eat_date == Date.current
      self.rice_kcal_per_bowl = user.profile&.rice_kcal_per_bowl.to_i
    else
    end
  end

  def calculate_total_calories
    bowls = rice_bowls.to_i
    rice_calorie = bowls * rice_kcal_per_bowl.to_i
    self.base_calorie = base_calorie.to_i
    self.calorie = base_calorie.to_i + rice_calorie
  end
end
