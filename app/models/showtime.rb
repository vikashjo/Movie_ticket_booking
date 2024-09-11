class Showtime < ApplicationRecord
  belongs_to :movie
  belongs_to :hall
  has_many :tickets
  has_many :users, through: :tickets
  has_and_belongs_to_many :seats, dependent: :destroy

  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_time_after_start_time

  after_create :assign_seats

  def assign_seats
    # Assign all seats in the hall to this showtime
    self.hall.seats.each do |seat|
      self.seats << seat unless self.seats.include?(seat)
    end
  end

  private

  def end_time_after_start_time
    if end_time <= start_time
      errors.add(:end_time, "must be after the start time")
    end
  end

end
