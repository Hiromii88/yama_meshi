class FavoritesController < ApplicationController
  before_action :require_active_user

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @active_user.favorite(@recipe)

    ingredients = @recipe.ingredients

    if @active_user.line_user_id.present?
      LineNotifier.push_message(
        line_user_id: @active_user.line_user_id,
        message: "📌 お気に入り登録しました！\n" \
                  "#{@recipe.name} (#{@recipe.calories} kcal)\n\n" \
                  "🛒 材料:\n" \
                  "#{ingredients.join("\n")}"
        )
    end
  end

  def destroy
    @recipe = @active_user.favorites.find(params[:id]).recipe
    @active_user.unfavorite(@recipe)
  end

  private

  def require_active_user
    unless @active_user
      redirect_to root_path, alert: 'ログインまたはLINE友達登録が必要です'
    end
  end
end
