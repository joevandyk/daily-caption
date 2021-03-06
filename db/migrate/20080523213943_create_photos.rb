class CreatePhotos < ActiveRecord::Migration
  def self.up
    transaction do
      create_table :photos do |t|
        t.column :flickr_id, :string, :null => false
        t.column :square, :text
        t.column :thumbnail, :text
        t.column :small, :text
        t.column :medium, :text
        t.column :large, :text
        t.column :original, :text
        t.column :state, :string
        t.column :author, :text
        t.column :photostream, :text
        t.column :captioned_at, :datetime
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :photos
  end
end
