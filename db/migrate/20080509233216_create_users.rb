class CreateUsers < ActiveRecord::Migration
  def self.up
    transaction do
      create_table :users do |t|
        t.integer :site_id
        t.integer :site_user_id, :limit => 8
        t.string  :session_key
        t.string :username
        t.string :email
        t.string :profile_url
        t.string :profile_image_url
        t.timestamps
      end
      add_index :users, :site_id
      add_index :users, :site_user_id
      add_index :users, :session_key
    end
  end

  def self.down
    drop_table :users
  end
end
