class AddImageDataToCalorieRecords < ActiveRecord::Migration[7.2]
  def change
    add_column :calorie_records, :image_data, :jsonb
  end
end
