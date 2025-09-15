class Recipe < ApplicationRecord
  has_one_attached :image
  has_many :favorites, dependent: :destroy
  has_many :favorites_users, through: :favorites, source: :user
end
