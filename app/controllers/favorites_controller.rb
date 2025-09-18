class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @recipe = Recipe.find(params[:recipe_id])
    current_user.favorite(@recipe)

    ingredients = @recipe.ingredients

    # LINE通知を呼び出し
    LineNotifier.push_message(
      user_id: "Ub709f8252c03e49869cdd40c22941739", # ←自分のLINE ID
      message: "📌 お気に入り登録しました！\n" \
               "#{@recipe.name} (#{@recipe.calories} kcal)\n\n" \
               "🛒 材料:\n" \
               "#{ingredients.join("\n")}"
    )
  end

  def destroy
    @recipe = current_user.favorites.find(params[:id]).recipe
    current_user.unfavorite(@recipe)
  end
end
