class Hall < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :capacity, presence: true

  has_many :showtimes
end
