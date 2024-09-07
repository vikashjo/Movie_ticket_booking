class User < ApplicationRecord
  has_secure_password
  validates :name, uniqueness: true
  validates :email, uniqueness: true

  has_many :tickets
  has_many :showtimes, through: :tickets
  has_many :reviews, dependent: :destroy
end
