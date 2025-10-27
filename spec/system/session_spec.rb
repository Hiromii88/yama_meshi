require 'rails_helper'

RSpec.describe 'Users session Feature', type: :system do
  describe 'ログイン機能' do
    let!(:user) { create(:user) }
    it 'ログイン成功' do
      visit new_user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      expect(page).to have_content('ログインしました')
    end
    it 'メールアドレスの空欄でログイン失敗' do
      visit new_user_session_path
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: 'xxxxxx'
      click_button 'ログイン'
      expect(page).to have_content('メールアドレスまたはパスワードが正しくありません')
    end

    it '登録のないユーザーでログイン失敗' do
      visit new_user_session_path
      fill_in 'メールアドレス', with: 'xxx@xxx.com'
      fill_in 'パスワード', with: 'xxxxxx'
      click_button 'ログイン'
      expect(page).to have_content('メールアドレスまたはパスワードが正しくありません')
    end
    it 'ログアウト成功' do
      user = create(:user)
      visit new_user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      expect(page).to have_content('ログインしました')

      click_button 'ログアウト'
      expect(page).to have_content('ログアウトしました')
    end
  end
end
