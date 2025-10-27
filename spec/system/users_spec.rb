require 'rails_helper'

RSpec.describe 'Users session Feature', type: :system do
  describe 'ユーザー新規登録' do
    it 'ユーザー新規登録成功' do
      visit new_user_registration_path
      fill_in 'メールアドレス', with: 'test@test.com'
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワード確認', with: 'password'
      click_button '新規登録'
      expect(page).to have_content('アカウントを登録しました')
    end

    it '未入力のため登録失敗' do
      visit new_user_registration_path
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワード確認', with: 'password'
      click_button '新規登録'
      expect(page).to have_content('メールアドレスを入力してください')
    end

    it 'すでに登録のあるメールアドレスのため登録失敗' do
      user = create(:user)
      visit new_user_registration_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      fill_in 'パスワード確認', with: user.password
      click_button '新規登録'
      expect(page).to have_content('メールアドレスは既に登録されています')
    end
  end
end
