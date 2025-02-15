class Driver < ApplicationRecord
  has_many :trips, dependent: :nullify
  
  # validations
  
  validates :name, presence: true
  validates :vin, presence: true
  
  
  # methods
  
  def average_rating
    if self.trips.empty?
      average = nil
    else
      total_rating = 0
      counter = 0
      self.trips.each do |trip|
        if !(trip.rating.nil?)
          total_rating += trip.rating
          counter += 1
        end
      end
      average = (total_rating.to_f / counter).round(2)
    end
    return average
  end
  
  def total_earnings
    total = 0
    self.trips.each do |trip|
      total += trip.cost
    end
    return total
  end
  
  # The driver gets 80% of the trip cost after a fee of $1.65 is subtracted
  def driver_earnings
    before_fee = self.total_earnings
    
    if before_fee == 0
      return 0
    end
    
    after_fee = (before_fee - 165)
    
    percentage = 0.8
    driver_earnings = after_fee * percentage
    
    return driver_earnings
  end
  
  def go_online
    self.active = true
    
    if self.save
      return self
    else
      return false
    end
  end
  
  def go_offline
    self.active = false
    
    if self.save
      return self
    else
      return false
    end
  end
  
  def avatar_image
    driver_id = self.id
    avatar_link = "https://api.adorable.io/avatars/200/" << driver_id.to_s << ".png"
    
    return avatar_link
  end
  
  # select active driver, set status to inactive
  def self.get_driver
    available_driver = Driver.find_by(active: true)
    
    if available_driver
      available_driver.go_offline
      return available_driver
    else
      return nil
    end
  end
  
end
