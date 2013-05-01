class AddHistoryTable < ActiveRecord::Migration
  def up
    create_table :history do |t|
      t.string  :winner
      t.string  :looser
      t.integer :winner_points, :default => 0
      t.integer :looser_points, :default => 0
      
      t.timestamps
    end
  end
  
  def down
    drop_table :history
  end
end
