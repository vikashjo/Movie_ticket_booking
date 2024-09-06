class Movie < ApplicationRecord
  has_many :showtimes

  validates :title, :genre, :duration, :director, :description, :language, presence: true
end
