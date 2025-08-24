require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  let(:user) { create(:user, :owner) }
  let(:category) { create(:category) }
  let(:valid_attributes) do
    {
      name: 'Test Product',
      description: 'Test Description',
      category: category.id,
      image_url: 'https://example.com/image.jpg'
    }
  end

  describe 'GET #index' do
    let!(:products) { create_list(:product, 3) }

    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'returns products data' do
      get :index
      json_response = JSON.parse(response.body)

      expect(json_response['data']).to be_an(Array)
      expect(json_response['data'].length).to eq(3)
    end

    context 'with name filter' do
      let!(:matching_product) { create(:product, name: 'Special Product') }

      it 'filters products by name' do
        get :index, params: { name: 'Special' }
        json_response = JSON.parse(response.body)

        expect(json_response['data'].length).to eq(1)
        expect(json_response['data'].first['name']).to eq('Special Product')
      end
    end
  end

  describe 'GET #show' do
    let(:product) { create(:product) }

    it 'returns a successful response' do
      get :show, params: { id: product.id }
      expect(response).to have_http_status(:ok)
    end

    it 'returns product data' do
      get :show, params: { id: product.id }
      json_response = JSON.parse(response.body)

      expect(json_response['data']['id']).to eq(product.id)
      expect(json_response['data']['name']).to eq(product.name)
    end
  end

  describe 'POST #create' do
    before do
      allow(controller).to receive(:current_user).and_return(user)
      allow(controller).to receive(:authorize!).and_return(true)
    end

    context 'with valid parameters' do
      it 'creates a new product' do
        expect {
          post :create, params: valid_attributes
        }.to change(Product, :count).by(1)
      end

      it 'returns a successful response' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
      end

      it 'returns the created product data' do
        post :create, params: valid_attributes
        json_response = JSON.parse(response.body)

        expect(json_response['data']['name']).to eq('Test Product')
        expect(json_response['message']).to eq('Product created successfully.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { name: '', description: '' } }

      it 'does not create a new product' do
        expect {
          post :create, params: invalid_attributes
        }.not_to change(Product, :count)
      end

      it 'returns an error response' do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    let(:product) { create(:product, owner: user) }
    let(:new_attributes) { { name: 'Updated Product Name' } }

    before do
      allow(controller).to receive(:current_user).and_return(user)
      allow(controller).to receive(:authorize!).and_return(true)
    end

    context 'with valid parameters' do
      it 'updates the product' do
        patch :update, params: { id: product.id }.merge(new_attributes)
        product.reload
        expect(product.name).to eq('Updated Product Name')
      end

      it 'returns a successful response' do
        patch :update, params: { id: product.id }.merge(new_attributes)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { name: '' } }

      it 'returns an error response' do
        patch :update, params: { id: product.id }.merge(invalid_attributes)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:product) { create(:product, owner: user) }

    before do
      allow(controller).to receive(:current_user).and_return(user)
      allow(controller).to receive(:authorize!).and_return(true)
    end

    it 'destroys the product' do
      expect {
        delete :destroy, params: { id: product.id }
      }.to change(Product, :count).by(-1)
    end

    it 'returns a successful response' do
      delete :destroy, params: { id: product.id }
      expect(response).to have_http_status(:ok)
    end
  end
end

