class FavoritesController < ApplicationController
  before_action :set_recipe

  def create
    current_user.favorite(@recipe)
    redirect_to @recipe, notice: "お気に入りに追加しました"
  end

  def destroy
    current_user.unfavorite(@recipe)
    redirect_to @recipe, notice: "お気に入りから外しました"
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:recipe_id])
  end
end
