# モデル生成
gmodel:
	docker compose exec web bin/rails g model $(name)

# コントローラー生成
gcontroller:
	docker compose exec web bin/rails g controller $(name)

# マイグレーション
migrate:
	docker compose exec web bin/rails db:migrate

# コンソール起動
console:
	docker compose exec web bin/rails console

# Bundler install
bundle:
	docker compose exec web bundle install

# 全テスト実行
spec:
	docker compose exec web bundle exec rspec

# 特定ファイルだけ
spec-file:
	docker compose exec web bundle exec rspec $(FILE)

# 失敗したテストだけ再実行
spec-fail:
	docker compose exec web bundle exec rspec --only-failures