class AddLegendToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :legend, :boolean
  end

  def self.down
    remove_column :users, :legend
  end
end
