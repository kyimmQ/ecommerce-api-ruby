require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:address) }
    it { should validate_uniqueness_of(:email) }
    it { should have_secure_password }
  end

  describe 'associations' do
    it { should have_many(:user_roles).dependent(:destroy) }
    it { should have_many(:roles).through(:user_roles) }
    it { should have_many(:permissions).through(:roles) }
    it { should have_many(:products).with_foreign_key(:owner_id) }
    it { should have_many(:product_reviews).with_foreign_key(:user_id) }
    it { should have_many(:orders).with_foreign_key(:user_id) }
    it { should have_one(:shopping_cart).dependent(:destroy) }
  end

  describe 'callbacks' do
    it 'creates a shopping cart after user creation' do
      user = create(:user)
      expect(user.shopping_cart).to be_present
    end
  end

  describe '#can?' do
    let(:user) { create(:user) }
    let(:permission) { create(:permission, name: 'test_permission') }
    let(:role) { create(:role) }

    before do
      role.permissions << permission
      user.roles << role
    end

    it 'returns true when user has the permission' do
      expect(user.can?('test_permission')).to be true
    end

    it 'returns false when user does not have the permission' do
      expect(user.can?('nonexistent_permission')).to be false
    end
  end

  describe '#cart_items_count' do
    let(:user) { create(:user) }

    context 'when user has no cart items' do
      it 'returns 0' do
        expect(user.cart_items_count).to eq(0)
      end
    end

    context 'when user has cart items' do
      before do
        product_variant = create(:product_variant)
        user.shopping_cart.cart_items.create!(
          product_variant: product_variant,
          quantity: 3
        )
      end

      it 'returns the total quantity of items' do
        expect(user.cart_items_count).to eq(3)
      end
    end
  end

  describe '#have_cart_item?' do
    let(:user) { create(:user) }
    let(:product_variant) { create(:product_variant) }

    context 'when user has the item in cart' do
      before do
        user.shopping_cart.cart_items.create!(
          product_variant: product_variant,
          quantity: 1
        )
      end

      it 'returns true' do
        expect(user.have_cart_item?(product_variant.id)).to be true
      end
    end

    context 'when user does not have the item in cart' do
      it 'returns false' do
        expect(user.have_cart_item?(product_variant.id)).to be false
      end
    end
  end
end

