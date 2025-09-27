class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @recipe = Recipe.find(params[:recipe_id])
    current_user.favorite(@recipe)

    ingredients = @recipe.ingredients

    if current_user.line_user_id.present?
      LineNotifier.push_message(
        user_id: "current_user.line_user_id",
        message: "📌 お気に入り登録しました！\n" \
                 "#{@recipe.name} (#{@recipe.calories} kcal)\n\n" \
                 "🛒 材料:\n" \
                 "#{ingredients.join("\n")}"
        )
    end
  end

  def destroy
    @recipe = current_user.favorites.find(params[:id]).recipe
    current_user.unfavorite(@recipe)
  end
end
