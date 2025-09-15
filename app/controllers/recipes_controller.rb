class RecipesController < ApplicationController
  before_action :set_recipe

  def show
  end

  def result
    @kcal = params[:kcal]
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end
end
