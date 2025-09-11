class RecipesController < ApplicationController
  def show
    @recipe = Recipe.find(params[:id])
  end

  def result
    @recipe = Recipe.find(params[:id])
    @kcal   = params[:kcal]
  end
end
