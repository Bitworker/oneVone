class AddEloToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :elo, :after => :looses, :default => 1200
    end
  end
end
