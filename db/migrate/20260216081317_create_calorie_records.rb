class CreateCalorieRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :calorie_records do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :calorie
      t.integer :meal_type
      t.date :eat_date
      t.text :memo

      t.timestamps
    end
  end
end
