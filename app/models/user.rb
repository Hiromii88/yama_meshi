class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable
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
