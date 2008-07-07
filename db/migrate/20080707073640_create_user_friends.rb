class CreateUserFriends < ActiveRecord::Migration
  def self.up
    create_table :user_friends do |t|
      t.integer :user_id
      t.binary   :friend_ids
      t.timestamps
    end
  end

  def self.down
    drop_table :user_friends
  end
end
