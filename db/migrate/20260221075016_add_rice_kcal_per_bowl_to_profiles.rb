class AddRiceKcalPerBowlToProfiles < ActiveRecord::Migration[7.2]
  def change
    add_column :profiles, :rice_kcal_per_bowl, :integer, null: false, default: 0
  end
end
