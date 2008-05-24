class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.column :flickr_id, :string, :null => false
      t.column :square, :string
      t.column :thumbnail, :string
      t.column :small, :string
      t.column :medium, :string
      t.column :original, :string
      t.column :state, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
