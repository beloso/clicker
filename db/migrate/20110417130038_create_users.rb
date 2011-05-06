class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name, :null => false
      t.string :url, :default => '', :null => true
      t.integer :clicks_given
      t.integer :clicks_received
      t.boolean :legend
      #t.boolean :admin

      t.timestamps
    end
    
    add_index :users, :id,                :unique => true
    add_index :users, :name,              :unique => true
  end

  def self.down
    drop_table :users
  end
end
