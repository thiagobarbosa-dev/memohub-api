require 'rails_helper'

RSpec.describe 'Notebooks API', type: :request do
  include Requests::JsonHelpers
  include Requests::HeaderHelpers

  let!(:user) { create(:user) }
  let!(:notebooks) { create_list(:notebook, 5, user: user) }
  let(:token) { authorized_header(user)['Authorization'] }
  let(:other_user) { create(:user) }
  let!(:other_user_notebooks) { create_list(:notebook, 3, user: other_user) }
  let(:other_user_token) { authorized_header(other_user)['Authorization'] }

  describe 'GET /api/v1/users/:user_id/notebooks' do
    context 'when user is authenticated' do
      before { get "/api/v1/users/#{user.id}/notebooks", headers: { 'Authorization' => token } }

      it 'returns user notebooks' do
        expect(json).not_to be_empty
        expect(json.size).to eq(5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when user is not authenticated' do
      before { get "/api/v1/users/#{user.id}/notebooks" }

      it 'returns unauthorized status code' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET /api/v1/users/:user_id/notebooks/:id' do
    context 'when the record belongs to the user' do
      let(:notebook_id) { notebooks.first.id }

      before { get "/api/v1/users/#{user.id}/notebooks/#{notebook_id}", headers: { 'Authorization' => token } }

      it 'returns the notebook' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(notebook_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not belong to the user' do
      let(:notebook_id) { other_user_notebooks.first.id }

      before { get "/api/v1/users/#{user.id}/notebooks/#{notebook_id}", headers: { 'Authorization' => token } }

      it 'returns unauthorized status code' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /api/v1/users/:user_id/notebooks' do
    context 'with valid params' do
      let(:valid_attributes) { { title: 'Test Notebook', user_id: user.id } }

      it 'creates a new notebook' do
        expect {
          post "/api/v1/users/#{user.id}/notebooks", params: { notebook: valid_attributes }, headers: { 'Authorization' => token }
        }.to change(Notebook, :count).by(1)
      end

      it 'returns status code 201' do
        post "/api/v1/users/#{user.id}/notebooks", params: { notebook: valid_attributes }, headers: { 'Authorization' => token }
        expect(response).to have_http_status(201)
      end
    end
  end

  describe 'PUT /api/v1/users/:user_id/notebooks/:id' do
    let(:notebook_id) { notebooks.first.id }
    let(:new_attributes) { { title: 'Updated Notebook Title' } }

    context 'when the record belongs to the user' do
      before { put "/api/v1/users/#{user.id}/notebooks/#{notebook_id}", params: { notebook: new_attributes }, headers: { 'Authorization' => token } }

      it 'updates the notebook' do
        expect(json['title']).to eq(new_attributes[:title])
      end
  
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not belong to the user' do
      before { put "/api/v1/users/#{user.id}/notebooks/#{notebook_id}", params: { notebook: new_attributes }, headers: { 'Authorization' => other_user_token } }

      it 'returns unauthorized status code' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'DELETE /api/v1/users/:user_id/notebooks/:id' do
    let(:notebook_id) { notebooks.first.id }

    context 'when the record belongs to the user' do
      it 'destroys the requested notebook' do
        expect {
          delete "/api/v1/users/#{user.id}/notebooks/#{notebook_id}", headers: { 'Authorization' => token }
        }.to change(Notebook, :count).by(-1)
      end

      it 'returns status code 204' do
        delete "/api/v1/users/#{user.id}/notebooks/#{notebook_id}", headers: { 'Authorization' => token }
        expect(response).to have_http_status(204)
      end
    end

    context 'when the record does not belong to the user' do
      it 'does not destroy the requested notebook' do
        expect {
          delete "/api/v1/users/#{user.id}/notebooks/#{notebook_id}", headers: { 'Authorization' => other_user_token }
        }.to_not change(Notebook, :count)
      end

      it 'returns unauthorized status code' do
        delete "/api/v1/users/#{user.id}/notebooks/#{notebook_id}", headers: { 'Authorization' => other_user_token }
        expect(response).to have_http_status(401)
      end
    end
  end
end
