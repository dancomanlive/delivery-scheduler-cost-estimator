class Delivery < ApplicationRecord
  validates :pickup_address, presence: true
  validates :delivery_address, presence: true
  validates :weight, presence: true, numericality: { greater_than: 0 }
  validates :distance, presence: true, numericality: { greater_than: 0 }
  validates :scheduled_time, presence: true
  validates :cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  
  # Calculate cost based on weight and distance before saving
  before_save :calculate_cost
  
  private
  
  def calculate_cost
    return if weight.nil? || distance.nil?

    # Base rates for cost calculation
    base_rate_per_km = 2.00  # $2 per kilometer
    rate_per_kg = 1.50       # $1.50 per kilogram
    
    # Calculate total cost: (distance × rate per km) + (weight × rate per kg)
    # Round to 2 decimal places for currency
    self.cost = ((distance * base_rate_per_km) + (weight * rate_per_kg)).round(2)
  end
end