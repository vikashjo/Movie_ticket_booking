class Ticket < ApplicationRecord
  belongs_to :showtime
  belongs_to :user
  belongs_to :seat

  validates :seat_id, presence: true
end
