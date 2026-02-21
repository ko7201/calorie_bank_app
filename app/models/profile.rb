class Profile < ApplicationRecord
    belongs_to :user
    before_validation :set_rice_kcal_per_bowl
    # ご飯のカロリーは、1グラムあたり約1.68kcalとする
    RICE_KCAL_PER_GRAM = 1.68

    enum gender: { male: 0, female: 1, other: 2 }
    enum activity_level: { low: 0, middle: 1, high: 2 }

    validates :age, presence: true,
            numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 120 }

    validates :height, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 300 }

    validates :weight, presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 500 }

    validates :activity_level, presence: true
    validates :gender, presence: true

    validates :weight_to_lose, presence: true,
            numericality: { greater_than: 0 }

    validates :rice_gram, presence: true,
            numericality: { only_integer: true, greater_than: 0 }

    ACTIVITY_NUMBER = {
        "low" => 1.5,
        "middle" => 1.75,
        "high" => 2.0
    }.freeze

    def activity_number
        ACTIVITY_NUMBER.fetch(activity_level)
    end

    def target_saving_calories
        weight_to_lose * 7000
    end

    def bmr_calculation
        if male?
            (10 * weight) + (6.25 * height) - (5 * age) + 5
        elsif female?
            (10 * weight) + (6.25 * height) - (5 * age) - 161
        else
            0
        end
    end

    def bmr
        bmr_calculation * activity_number
    end

    private
    # プロフィール保存時に、1杯あたりのカロリーを計算して固定する
    # （プロフィール変更によって過去の記録が変わらないようにするため
    def set_rice_kcal_per_bowl
        return if rice_gram.blank?
        self.rice_kcal_per_bowl = (RICE_KCAL_PER_GRAM * rice_gram).round
    end
end
