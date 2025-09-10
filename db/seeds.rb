require "csv"
require "json"

csv_path = Rails.root.join("db/csv/recipes_converted.csv")
default_image_path = Rails.root.join("db/seed_images/default.png")

CSV.foreach(csv_path, headers: true).with_index(1) do |row, i|
  recipe = Recipe.create!(
    name:        row["name"],
    calories:    row["calories"],
    ingredients: JSON.parse(row["ingredients"]),
    gear:        JSON.parse(row["gear"]),
    steps:       JSON.parse(row["steps"])
  )

  # 画像ファイル名をIDや行番号で推測する例（例: 1.png, 2.png…）
  image_path = Rails.root.join("db/seed_images", "#{i}.png")

  if File.exist?(image_path)
    recipe.image.attach(io: File.open(image_path), filename: "#{i}.png")
  elsif File.exist?(default_image_path)
    recipe.image.attach(io: File.open(default_image_path), filename: "default.png")
  end
end
