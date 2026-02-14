class ChangeHeightWeightToDecimalInProfiles < ActiveRecord::Migration[7.2]
  def change
    change_column :profiles, :height, :decimal, precision: 5, scale: 1
    change_column :profiles, :weight, :decimal, precision: 5, scale: 1
  end
end
