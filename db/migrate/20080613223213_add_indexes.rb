class AddIndexes < ActiveRecord::Migration
  def self.up
    transaction do
      add_index :captions, :photo_id
      add_index :captions, :user_id
      add_index :captions, :votes_count
      add_index :captions, :created_at

      add_index :comments, :user_id
      add_index :comments, :caption_id
      add_index :comments, :created_at

      add_index :photos, :captioned_at

      add_index :users, :site_id
      add_index :users, :site_user_id
    end
  end

  def self.down
    transaction do
    end
  end
end
