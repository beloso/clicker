class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :url
      t.integer :clicks_given
      t.integer :clicks_received
      #t.boolean :admin

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
