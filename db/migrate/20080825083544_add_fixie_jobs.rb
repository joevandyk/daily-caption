class AddFixieJobs < ActiveRecord::Migration
  def self.up
    create_table :fixie_jobs do |t|
      t.column :the_method, :string,  :null => false
      t.column :klass,      :text,    :null => false
      t.column :options,    :string
      t.column :record_id,  :integer
      t.column :created_at, :datetime
      t.column :priority,   :integer
    end
  end

  def self.down
    drop_table :fixie_jobs
  end
end
