require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  include Requests::JsonHelpers
  include Requests::HeaderHelpers

  let!(:users) { create_list(:user, 5) }
  let(:token) { authorized_header(users.first)['Authorization'] }

  describe 'GET /api/v1/users' do
    context 'when user is authenticated' do
      before { get '/api/v1/users', headers: { 'Authorization' => token } }

      it 'returns users' do
        expect(json).not_to be_empty
        expect(json.size).to eq(5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when user is not authenticated' do
      before { get '/api/v1/users' }

      it 'returns unauthorized status code' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET /api/v1/users/:id' do
    let(:user_id) { users.first.id }

    context 'when user is authenticated' do
      before { get "/api/v1/users/#{user_id}", headers: { 'Authorization' => token } }

      context 'when the record exists' do
        it 'returns the user' do
          expect(json).not_to be_empty
          expect(json['id']).to eq(user_id)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the record does not exist' do
        let(:user_id) { 100 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/User not found/)
        end
      end
    end

    context 'when user is not authenticated' do
      before { get "/api/v1/users/#{user_id}" }

      it 'returns unauthorized status code' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /api/v1/users' do
    let(:valid_attributes) { { name: 'John Doe', login: 'johndoe', email: 'john@example.com', password: 'password' } }

    context 'when user is authenticated' do
      before { post '/api/v1/users', params: { user: valid_attributes }, headers: { 'Authorization' => token } }

      it 'creates a new user' do
        expect(json['name']).to eq('John Doe')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when user is not authenticated' do
      before { post '/api/v1/users', params: { user: valid_attributes } }

      it 'returns unauthorized status code' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'PUT /api/v1/users/:id' do
    let(:user_id) { users.first.id }
    let(:new_attributes) { { name: 'Updated Name' } }

    context 'when user is authenticated' do
      before { put "/api/v1/users/#{user_id}", params: { user: new_attributes }, headers: { 'Authorization' => token } }

      it 'updates the user' do
        expect(json['name']).to eq('Updated Name')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when user is not authenticated' do
      before { put "/api/v1/users/#{user_id}", params: { user: new_attributes } }

      it 'returns unauthorized status code' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'DELETE /api/v1/users/:id' do
    let(:user_id) { users.first.id }

    context 'when user is authenticated' do
      before { delete "/api/v1/users/#{user_id}", headers: { 'Authorization' => token } }

      it 'deletes the user' do
        expect(User.find_by(id: user_id)).to be_nil
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when user is not authenticated' do
      before { delete "/api/v1/users/#{user_id}" }

      it 'returns unauthorized status code' do
        expect(response).to have_http_status(401)
      end
    end
  end
end
