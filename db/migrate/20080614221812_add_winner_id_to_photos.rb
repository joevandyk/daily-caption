class AddWinnerIdToPhotos < ActiveRecord::Migration
  def self.up
    transaction do
      add_column :photos, :winner_id, :integer
    end
  end

  def self.down
  end
end
