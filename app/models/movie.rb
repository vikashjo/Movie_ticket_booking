class Movie < ApplicationRecord
  has_many :showtimes
  has_many :reviews, dependent: :destroy

  validates :title, :genre, :duration, :director, :description, :language, presence: true
end
