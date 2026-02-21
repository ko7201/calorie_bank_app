class ChangeRiceKcalPerBowlDefaultOnProfiles < ActiveRecord::Migration[7.2]
  def change
    change_column_default :profiles, :rice_kcal_per_bowl, from: 0, to: nil
    change_column_null :profiles, :rice_kcal_per_bowl, true
  end
end
