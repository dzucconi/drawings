class CreateProductionFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :production_files do |t|
      t.string :name
      t.integer :attachment_filesize
      t.string :attachment_content_type
      t.string :attachment_filename
      t.references :drawing, foreign_key: true

      t.timestamps
    end
  end
end
