class Hall < ApplicationRecord
  validates :name, presence: true

  has_many :showtimess
end
