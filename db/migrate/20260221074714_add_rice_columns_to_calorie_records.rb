class AddRiceColumnsToCalorieRecords < ActiveRecord::Migration[7.2]
  def change
    add_column :calorie_records, :rice_bowls, :integer, null: false, default: 0
    add_column :calorie_records, :rice_kcal_per_bowl, :integer, null: false, default: 0
  end
end
