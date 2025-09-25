require "csv"
require "json"
require "open-uri"  # S3 の画像 URL を開くために必要

csv_path = Rails.root.join("db/csv/recipes_converted.csv")

# S3 上のベース URL
s3_base_url = "https://#{Rails.application.credentials.dig(:aws, :bucket)}.s3.#{Rails.application.credentials.dig(:aws, :region)}.amazonaws.com/seeds"

CSV.foreach(csv_path, headers: true).with_index(1) do |row, i|
  recipe = Recipe.create!(
    name:        row["name"],
    calories:    row["calories"],
    ingredients: JSON.parse(row["ingredients"]),
    gear:        JSON.parse(row["gear"]),
    steps:       JSON.parse(row["steps"])
  )

  image_url = "#{s3_base_url}/#{i}.png"

  begin
    recipe.image.attach(
      io: URI.open(image_url),
      filename: "#{i}.png"
    )
  rescue OpenURI::HTTPError
    Rails.logger.info "No image for recipe #{i}, skipping attach"
  end
end
