require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe 'アソシエーション' do
    it { should have_one_attached(:image) }
    it { should have_many(:favorites).dependent(:destroy) }
    it { should have_many(:favorites_users).through(:favorites).source(:user) }
  end
end
