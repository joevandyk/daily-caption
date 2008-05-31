class CreateVotes < ActiveRecord::Migration
  def self.up
    transaction do
      create_table :votes do |t|
        t.integer :user_id
        t.integer :caption_id

        t.timestamps
      end
      add_index :votes, :user_id
      add_index :votes, :caption_id
    end
  end

  def self.down
    drop_table :votes
  end
end
