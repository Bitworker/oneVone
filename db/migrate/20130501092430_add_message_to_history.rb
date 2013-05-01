class AddMessageToHistory < ActiveRecord::Migration
  def change
    change_table :history do |t|
      t.string :message, :after => :id
    end
  end
end
