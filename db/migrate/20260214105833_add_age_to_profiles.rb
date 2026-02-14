class AddAgeToProfiles < ActiveRecord::Migration[7.2]
  def change
    add_column :profiles, :age, :integer
  end
end
