require "csv"
require "json"
require "open-uri"  # S3 の URL を開くために必要

csv_path = Rails.root.join("db/csv/recipes_converted.csv")

CSV.foreach(csv_path, headers: true).with_index(1) do |row, i|
  recipe = Recipe.create!(
    name:        row["name"],
    calories:    row["calories"],
    ingredients: JSON.parse(row["ingredients"]),
    gear:        JSON.parse(row["gear"]),
    steps:       JSON.parse(row["steps"])
  )

  # S3 上のファイル URL
  s3_base_url = "https://#{Rails.application.credentials.dig(:aws, :bucket)}.s3.#{Rails.application.credentials.dig(:aws, :region)}.amazonaws.com/seeds"
  image_url   = "#{s3_base_url}/#{i}.png"
  default_url = "#{s3_base_url}/default.png"

  begin
    recipe.image.attach(
      io: URI.open(image_url),
      filename: "#{i}.png"
    )
  rescue OpenURI::HTTPError
    recipe.image.attach(
      io: URI.open(default_url),
      filename: "default.png"
    )
  end
end
