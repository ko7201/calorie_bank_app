class DropPhotosTable < ActiveRecord::Migration[7.2]
  def change
    drop_table :photos
  end
end
