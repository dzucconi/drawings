class CreateFormats < ActiveRecord::Migration[5.1]
  def change
    create_table :formats do |t|
      t.float :width
      t.float :height
      t.string :unit
      t.string :name

      t.timestamps
    end
  end
end
