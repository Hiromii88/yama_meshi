require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    context 'Line_user_idがない場合' do
      it 'Email・password・password_confirmがあれば有効である' do
        user = build(:user)
        expect(user).to be_valid
        expect(user.errors).to be_empty
      end

      it 'emailがなければ無効である' do
        user = build(:user, email: nil)
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include 'メールアドレスを入力してください'
      end

      it 'すでにあるemailは無効である' do
        first_user = create(:user)
        duplicate_user = build(:user, email: first_user.email)
        expect(duplicate_user).to be_invalid
        expect(duplicate_user.errors.full_messages).to include 'メールアドレスは既に登録されています'
      end

      it 'emailの形式が正しくなければ無効である' do
        user = build(:user, email: 'invalid_email')
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include 'メールアドレスは不正な値です'
      end

      it 'passwordがなければ無効である' do
        user = build(:user, password: nil)
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include 'パスワードを入力してください'
      end

      it 'passwordが6文字未満は無効である' do
        user = build(:user, password: '12345', password_confirmation: '12345')
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include 'パスワード6文字以上で入力してください'
      end

      it 'passwordとpassword_confirmationが不一致だと無効' do
        user = build(:user, password_confirmation: 'pass')
        expect(user).to be_invalid
        expect(user.errors.full_messages).to include 'パスワード確認が一致しません'
      end
    end

    context 'line_user_idがある場合' do
      it 'Email・passwordがなくても有効である' do
        user = User.create(email: nil, password: nil, password_confirmation: nil, line_user_id: 'abc123')
        expect(user).to be_valid
        expect(user.errors).to be_empty
      end

      it 'email・passwordがあっても有効である' do
        user = build(:user, line_user_id: 'abc123')
        expect(user).to be_valid
        expect(user.errors).to be_empty
      end
    end
  end
end
