class Ticket < ApplicationRecord
  belongs_to :showtime
  belongs_to :user

  validates :seat_number, presence: true
  validate :seat_availability

  def seat_availability
    if Ticket.exists?(showtime_id: showtime_id, seat_number: seat_number)
      errors.add(:seat_number,"#{seat_number} is already booked, Please choose some other seat")
    end
  end
end
