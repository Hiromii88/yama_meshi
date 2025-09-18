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
    Recipe.where(calories: lower_bound..upper_bound).order("RANDOM()").first
  end
end
