require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe 'アソシエーション' do
    it { should belong_to(:user) }
    it { should belong_to(:recipe) }
  end

  describe 'バリデーション' do
    # user_id と recipe_id の組み合わせが一意であることを確認
    it { should validate_uniqueness_of(:user_id).scoped_to(:recipe_id) }
  end
end
