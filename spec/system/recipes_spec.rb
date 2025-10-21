require 'rails_helper'

RSpec.describe 'Recipe Suggest Feature', type: :system do
  describe 'メイン機能：カロリー入力によるレシピ提案' do
    it 'ユーザーがカロリーを入力するとおすすめレシピが表示される' do
      visit root_path
      fill_in 'カロリー', with: '500'
      click_button '決定'

      expect(page).to have_content('おすすめのメニューはこれ！')
      expect(page).to have_selector('.recipe-card')
    end

    it '不正なカロリー入力（1001以上）の場合はエラーメッセージを表示する' do
      visit root_path
      fill_in 'カロリー', with: '1001'
      click_button '決定'

      expect(page).to have_content('カロリーは1000以下で入力してください')
    end
  end
end
