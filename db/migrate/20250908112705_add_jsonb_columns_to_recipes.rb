class AddJsonbColumnsToRecipes < ActiveRecord::Migration[7.1]
  def change
    change_column_default :recipes, :ingredients, from: nil, to: []
    change_column_default :recipes, :gear, from: nil, to: []
    change_column_default :recipes, :steps, from: nil, to: []
  end
end
