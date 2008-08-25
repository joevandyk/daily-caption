class AddFixieJobs < ActiveRecord::Migration
  def self.up
    create_table :fixie_jobs do |t|
      t.column :the_method,   :string,  :null => false
      t.column :klass,        :text,    :null => false
      t.column :options,      :text
      t.column :record_id,    :integer
      t.column :created_at,   :datetime
      t.column :priority,     :integer
      t.column :started_at,   :datetime
      t.column :finished_at,  :datetime
    end
    add_index :fixie_jobs, :created_at
    add_index :fixie_jobs, :started_at
    add_index :fixie_jobs, :priority
  end

  def self.down
    drop_table :fixie_jobs
  end
end
