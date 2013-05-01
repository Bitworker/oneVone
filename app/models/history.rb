class History < ActiveRecord::Base
  set_table_name "history"
  
  attr_accessible :message, :winner, :winner_points, :looser, :looser_points
end
