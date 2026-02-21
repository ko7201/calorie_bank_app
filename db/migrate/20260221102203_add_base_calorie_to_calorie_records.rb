class AddBaseCalorieToCalorieRecords < ActiveRecord::Migration[7.2]
  def change
    add_column :calorie_records, :base_calorie, :integer
  end
end
