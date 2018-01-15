class CreateDrawings < ActiveRecord::Migration[5.1]
  def change
    create_table :drawings do |t|
      t.string :title
      t.references :format, index: true
      t.string :image_content_type
      t.string :image_filename
      t.integer :image_filesize
      t.integer :image_width
      t.integer :image_height

      t.timestamps
    end
  end
end
