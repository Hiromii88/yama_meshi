class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :name
      t.integer :calories
      t.integer :weight
      t.string :image_url
      t.jsonb :ingredients
      t.jsonb :gear
      t.jsonb :steps

      t.timestamps
    end
  end
end
