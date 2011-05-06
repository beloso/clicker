# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

User.create([
  {
    :name => "ForcadoRules",
    :url  => "http://www.darkthrone.com/recruiter/outside/B7OE4OA0OD8OD5OF1",
    :clicks_given => 25,
    :clicks_received => 0
  },
  {
    :name => "Angele",
    :url  => "http://www.darkthrone.com/recruiter/outside/B7OD8OE6OC2OF9OD5",
    :clicks_given => 10,
    :clicks_received => 10
  },
  {
    :name => "Dadi",
    :url  => "http://www.darkthrone.com/recruiter/outside/D5OD5OD5OB7OB7OF1OA0",
    :clicks_given => 100,
    :clicks_received => 15
  },
  {
    :name => "jonash_",
    :url  => "http://www.darkthrone.com/recruiter/outside/E6OE6OF1OC2OE6OD5",
    :clicks_given => 25,
    :clicks_received => 50
  },
  {
    :name => "b0nk1e",
    :url  => "http://www.darkthrone.com/recruiter/outside/A0OF9OA3OC2OE6OF9OB7",
    :clicks_given => 100,
    :clicks_received => 50
  },
  {
    :name => "Witan",
    :legend => true
  },
  ])
  
Admin.create([
  {
    :name => "Admin",
    :email => "admin@clicker.com",
    :password => "password"
  }
  ])
