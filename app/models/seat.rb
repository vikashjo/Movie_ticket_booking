class Seat < ApplicationRecord
    belongs_to :hall
    has_and_belongs_to_many :showtimes
    has_one :ticket

    enum status: {available: 0, booked: 1}
end
