require 'open-uri'

class User < ActiveRecord::Base
  MINIMUM_CREDITS = Configurable.minimum_credits
    
  REG = /([a-zA-Z0-9_]*) has recruited too many people today.|You are being recruited into the army of ([a-zA-Z0-9_]*)/
  
  before_validation :default_values
    
  def default_values
    self.legend            = false     unless self.legend
    if isClickable? && hasLink?
      self.name            = find_name if     self.name.blank?
      self.clicks_given    = Configurable.starting_clicks       unless self.clicks_given
      self.clicks_received = 0         unless self.clicks_received
    else
      self.clicks_given    = 0         unless self.clicks_given
      self.clicks_received = 0         unless self.clicks_received
    end 
  end
  
  def isClickable?
    !self.legend 
  end
  
  def hasLink?
    !self.url.blank?
  end
  
  def hasName?
    !self.name.blank?
  end
  
  def credits
    self.clicks_given - self.clicks_received
  end
  
  def find_name
    doc = Nokogiri::HTML(open(self.url))

    doc.css(wrap_content).text.scan(REG).flatten.compact.first    
  end
  
  ### Class Methods
  
  def self.clickable_users
    where("clicks_given - clicks_received >= ? AND legend = 'f'", MINIMUM_CREDITS).ordered_by_credits
  end
  
  def self.legend_users
    where("legend = 't'").order("clicks_given")
  end
  
  def self.frozen_users
     where("clicks_given - clicks_received < ?", MINIMUM_CREDITS)
  end
  
  def self.delete_frozen
    delete_all(["clicks_given - clicks_received < ?", -5])
  end
  
  def self.ordered_by_credits
    order("(clicks_given - clicks_received) DESC")
  end
  
  def self.reset_counters
    update_all "clicks_given = 25, clicks_received = 0" , "legend = 'f'"
    update_all "clicks_given = 0, clicks_received = 0" , "legend = 't'"
  end
  
  def gain_credit
    self.clicks_given += 1
    self.save
  end
  
  def lose_credit
    self.clicks_received += 1
    self.save
  end
  
  ### Validations
  
  validates                 :name, :presence => true, :if => :hasLink?
  validates_uniqueness_of   :name, :if => :hasLink?
  
  validates                 :url,  :presence => true, :if => :isClickable?
  validates_format_of       :url,  :with     => /\A(http\:\/\/)?(gold|www)?(\.)?darkthrone\.com\/recruiter\/outside\/[A-Z0-9]+\Z/, :if => :isClickable?
  validates_uniqueness_of   :url,  :if       => :isClickable?
  
  validates_numericality_of :clicks_given,    :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :clicks_received, :only_integer => true, :greater_than_or_equal_to => 0
end
