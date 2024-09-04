class Showtime < ApplicationRecord
  belongs_to :movie
  belongs_to :hall
  has_many :tickets
  has_many :users, through: :tickets

  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    if end_time <= start_time
      errors.add(:end_time, "must be after the start time")
    end
  end

end
