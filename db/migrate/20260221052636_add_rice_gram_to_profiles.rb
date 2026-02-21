class AddRiceGramToProfiles < ActiveRecord::Migration[7.2]
  def change
    add_column :profiles, :rice_gram, :integer
  end
end
