class User < ActiveRecord::Base
  before_validation :default_values
  def default_values
    self.clicks_given    = 25 unless self.clicks_given
    self.clicks_received = 0  unless self.clicks_received
    # => self.admin           = false unless self.admin
  end
  
  def credits
    credits = self.clicks_given - self.clicks_received
  end
  
  validates :name,        :presence   => true
  
  validates :url,         :presence   => true
  validates_format_of     :url, :with => /\A(http\:\/\/)?(gold|www)?(\.)?darkthrone\.com\/recruiter\/outside\/[A-Z0-9]+\Z/
  
  validates_numericality_of :clicks_given,    :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :clicks_received, :only_integer => true, :greater_than_or_equal_to => 0
end
