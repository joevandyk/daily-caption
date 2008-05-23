class CreateCaptions < ActiveRecord::Migration
  def self.up
    transaction do
      create_table :captions do |t|
        t.integer :photo_id
        t.text :caption
        t.integer :user_id

        t.timestamps
      end
    end
  end

  def self.down
    drop_table :captions
  end
end
