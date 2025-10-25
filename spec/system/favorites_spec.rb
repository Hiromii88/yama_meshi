require 'rails_helper'

RSpec.describe 'favorite feature', type: :system do
  let(:user) { create(:user) }
  let!(:recipe) { create(:recipe) }
  describe 'お気に入り機能：ログイン時と未ログイン時' do
    it '未ログイン時はお気に入りボタンを押すとログインページへ遷移する', js: true do
      visit root_path
      fill_in 'カロリー', with: '500'
      click_button '決定'
      find('[data-testid="favorite-button"]').click
      expect(page).to have_current_path(new_user_session_path, ignore_query: true)
    end

    it 'ログイン時はお気に入りボタンを押すとハートが赤く変わる' do
      login_as(user)
      visit root_path
      fill_in 'カロリー', with: '500'
      click_button '決定'
      find('[data-testid="favorite-button"]').click
      expect(page).to have_selector('button.text-red-500', wait: 3)
    end
  end
end