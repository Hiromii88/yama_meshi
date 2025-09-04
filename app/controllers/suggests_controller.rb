class SuggestsController < ApplicationController
  def show
    kcal = params[:kcal].to_i
    @recipe = recipe.over_kcal(kcal).order("RANDOM()").first
  end
end
