class User < ApplicationRecord
  devise :database_authenticatable, :registerable

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, unless: -> { line_user_id.present? }
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true, unless: -> { line_user_id.present? }

  has_many :favorites, dependent: :destroy
  has_many :favorite_recipes, through: :favorites, source: :recipe

  def favorite(recipe)
    favorites.find_or_create_by(recipe: recipe)
  end

  def unfavorite(recipe)
    favorites.find_by(recipe: recipe)&.destroy
  end

  def favorited?(recipe)
    favorites.exists?(recipe: recipe)
  end
end
