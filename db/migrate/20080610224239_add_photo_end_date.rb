class AddPhotoEndDate < ActiveRecord::Migration
  def self.up
    add_column :photos, :ended_captioning_at, :datetime
  end

  def self.down
  end
end
