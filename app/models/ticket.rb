class Ticket < ApplicationRecord
  belongs_to :showtime
  belongs_to :user
  belongs_to :seat

  validates :seat_id, presence: true

  SEAT_PRICES = {
    'classic' => 100,  
    'premium' => 150,  
    'recliner' => 200  
  }

  TIME_PRICES = {
    'matinee' => 50,   
    'evening' => 100  
  }
end
