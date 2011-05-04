class User < ActiveRecord::Base
  MINIMUM_CREDITS = -5
  
  before_validation :default_values
  
  def default_values
    self.clicks_given    = 25 unless self.clicks_given
    self.clicks_received = 0  unless self.clicks_received
  end
  
  def credits
    self.clicks_given - self.clicks_received
  end
  
  def self.clickable_users
    where("clicks_given - clicks_received >= ?", MINIMUM_CREDITS).ordered_by_credits
  end
  
  def self.frozen_users
     where("clicks_given - clicks_received < ?", MINIMUM_CREDITS)
  end
  
  def self.ordered_by_credits
    order("(clicks_given - clicks_received) DESC")
  end
  
  def gain_credit
    self.clicks_given += 1
    self.save!
  end
  
  def lose_credit
    self.clicks_received += 1
    self.save!
  end
  
  validates                 :name, :presence => true
  validates_uniqueness_of   :name
  
  validates                 :url,  :presence => true
  validates_format_of       :url,  :with     => /\A(http\:\/\/)?(gold|www)?(\.)?darkthrone\.com\/recruiter\/outside\/[A-Z0-9]+\Z/
  validates_uniqueness_of   :url
  
  validates_numericality_of :clicks_given,    :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :clicks_received, :only_integer => true, :greater_than_or_equal_to => 0
end
