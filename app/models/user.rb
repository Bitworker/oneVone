class User < ActiveRecord::Base 
  
  attr_accessible :ig_name, :wins, :looses, :elo
  
  validates_uniqueness_of :ig_name

  def ratio
    if looses == 0
      format("%1.2f", wins.to_f)
    else
      format("%1.2f", wins.to_f / looses.to_f)
    end
  end
end
