require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:category_id) }
    it { should validate_presence_of(:owner_id) }

    describe 'image_url validation' do
      let(:product) { build(:product) }

      it 'allows valid HTTP URLs' do
        product.image_url = 'http://example.com/image.jpg'
        expect(product).to be_valid
      end

      it 'allows valid HTTPS URLs' do
        product.image_url = 'https://example.com/image.jpg'
        expect(product).to be_valid
      end

      it 'allows blank image_url' do
        product.image_url = nil
        expect(product).to be_valid
      end

      it 'rejects invalid URLs' do
        product.image_url = 'not-a-url'
        expect(product).not_to be_valid
        expect(product.errors[:image_url]).to include('must be a valid URL')
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:owner).class_name('User') }
    it { should belong_to(:category) }
    it { should have_many(:product_variants).dependent(:destroy) }
  end

  describe '#price_range' do
    let(:product) { create(:product) }

    context 'with multiple variants at different prices' do
      before do
        create(:product_variant, product: product, price: 100.0)
        create(:product_variant, product: product, price: 200.0)
        create(:product_variant, product: product, price: 150.0)
      end

      it 'returns the minimum and maximum prices' do
        expect(product.price_range).to eq([ 100.0, 200.0 ])
      end
    end

    context 'with single variant' do
      before do
        create(:product_variant, product: product, price: 100.0)
      end

      it 'returns the same price for min and max' do
        expect(product.price_range).to eq([ 100.0, 100.0 ])
      end
    end
  end

  describe '#all_variants' do
    let(:product) { create(:product) }
    let(:product_option) { create(:product_option, name: 'Color') }
    let(:product_option_value) { create(:product_option_value, product_option: product_option, value: 'Red') }

    before do
      variant = create(:product_variant, product: product, price: 100.0, stock_quantity: 10)
      create(:variant_option_value, product_variant: variant, product_option_value: product_option_value)
    end

    it 'returns variants with option values' do
      variants = product.all_variants

      expect(variants).to be_an(Array)
      expect(variants.first).to include(:id, :sku, :price, :stock_quantity, :option_values)
      expect(variants.first[:option_values]).to be_an(Array)
      expect(variants.first[:option_values].first).to include(:option_name, :value)
    end

    it 'includes correct option information' do
      variants = product.all_variants
      option_value = variants.first[:option_values].first

      expect(option_value[:option_name]).to eq('Color')
      expect(option_value[:value]).to eq('Red')
    end
  end

  describe '#available_options' do
    let(:category) { create(:category) }
    let(:product) { create(:product, category: category) }

    it 'delegates to category.all_product_options' do
      expect(category).to receive(:all_product_options)
      product.available_options
    end
  end
end

