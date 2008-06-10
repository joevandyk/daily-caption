class AddCommentsCountToCaptions < ActiveRecord::Migration
  def self.up
    transaction do
      add_column :captions, :comments_count, :integer, :default => 0, :null => false
      Caption.reset_column_information
      Caption.find(:all).each do |caption|
        Caption.update_counters caption.id, :comments_count => caption.comments.count
      end
    end
  end

  def self.down
    remove_column :captions, :comments_count
  end
end
