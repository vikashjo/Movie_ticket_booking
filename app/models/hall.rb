class Hall < ApplicationRecord
  validates :name, presence: true

  has_many :showtimes
end
