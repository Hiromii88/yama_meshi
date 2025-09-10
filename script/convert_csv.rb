# script/convert_csv.rb
require 'csv'
require 'json'

input_path  = 'db/csv/recipes.csv'
output_path = 'db/csv/recipes_converted.csv'

content = File.read(input_path, encoding: "bom|utf-8:utf-8", invalid: :replace, undef: :replace, replace: "")
csv = CSV.parse(content, headers: true)

CSV.open(output_path, 'w', encoding: "UTF-8") do |csv_out|
  csv_out << csv.headers

  csv.each do |row|
    ["ingredients", "gear", "steps"].each do |col|
      if row[col] && !row[col].strip.empty?
        # 改行・カンマ・読点で分割
        items = row[col].split(/\r?\n|、|,/).map(&:strip).reject(&:empty?)
        row[col] = items.to_json
      else
        row[col] = [].to_json   # 空欄は [] に変換
      end
    end
    csv_out << row
  end
end

puts "✅ 変換完了！ => #{output_path}"
