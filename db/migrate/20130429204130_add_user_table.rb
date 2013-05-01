class AddUserTable < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string  :ig_name
      t.integer :wins, :default => 0
      t.integer :looses, :default => 0
      
      t.timestamps
    end
  end
  
  def down
    drop_table :users
  end
end
