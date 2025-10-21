class SuggestsController < ApplicationController
  def create
    @form = KcalForm.new(kcal_form_params)

    if @form.valid?
      @kcal = @form.kcal

      if (0..8).include?(@kcal)
        return redirect_to result_recipe_path(77)
      end

      @recipe = find_recipe(@kcal)

      if @recipe
        redirect_to result_recipe_path(@recipe, kcal: @kcal)
      else
        redirect_to root_path, alert: "条件にあうレシピが見つかりません"
      end
    else
      render "home/index", status: :unprocessable_entity
    end
  end

  private

  def kcal_form_params
    params.require(:kcal_form).permit(:kcal)
  end

  def find_recipe(kcal)
    lower_bound = [kcal - 20, 0].max
    upper_bound = kcal + 20
    recipes_in_range = Recipe.where(calories: lower_bound..upper_bound)

    return recipes_in_range.order("RANDOM()").first if recipes_in_range.exists?

    # なければ、全レシピの中から「kcalに最も近いレシピ」を探す
    closest_recipes = Recipe
      .select("*, ABS(calories - #{kcal}) AS diff")
      .order("diff ASC")

    # diff（差）が同じものが複数ある場合はランダムに選ぶ
    min_diff = closest_recipes.first&.diff
    candidates = closest_recipes.where("ABS(calories - ?) = ?", kcal, min_diff)

    candidates.order("RANDOM()").first
  end
end
