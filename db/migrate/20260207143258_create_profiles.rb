class CreateProfiles < ActiveRecord::Migration[7.2]
  
  def change
    create_table :profiles do |t|
      t.date :birth_date
      t.integer :height
      t.integer :weight
      t.integer :activity_level
      t.integer :weight_to_lose
      t.integer :gender
      t.integer :target_saving_calories
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
