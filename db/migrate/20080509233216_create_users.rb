class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :site_id
      t.string :username
      t.string :email
      t.string :profile_url
      t.string :profile_image_url

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
