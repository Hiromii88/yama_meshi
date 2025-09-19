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
      if row[col].nil? || row[col].strip.empty?
        row[col] = [].to_json   # 空欄は [] に変換
      else
        # JSONとして正しいかチェック
        begin
          JSON.parse(row[col])
          # 正常ならそのまま
        rescue JSON::ParserError
          puts "⚠️ JSON形式エラー: #{col} → #{row[col].inspect} （行: #{row.inspect}）"
          row[col] = [].to_json
        end
      end
    end
    csv_out << row
  end
end

puts "✅ 変換完了！ => #{output_path}"
