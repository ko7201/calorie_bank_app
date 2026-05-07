class AddAiFieldsToCalorieRecords < ActiveRecord::Migration[7.2]
  def change
    add_column :calorie_records, :ai_foods, :jsonb
    add_column :calorie_records, :ai_dish_name, :string
    add_column :calorie_records, :ai_confidence, :integer
    add_column :calorie_records, :is_donburi, :boolean, default: false, null: false
  end
end
