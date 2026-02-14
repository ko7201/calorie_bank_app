class Profile < ApplicationRecord
    belongs_to :user

    enum gender: { male: 0, female: 1, other: 2 }
    enum activity_level: { low: 0, middle: 1, high: 2 }

    ACTIVITY_NUMBER = {
        "low" => 1.5,
        "middle" => 1.25,
        "high" => 2.0
    }.freeze

    def activity_number
        ACTIVITY_NUMBER.fetch[activity_level]
    end 
end
