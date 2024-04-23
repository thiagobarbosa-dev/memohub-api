require 'rails_helper'

RSpec.describe 'Pages API', type: :request do
  include Requests::JsonHelpers
  include Requests::HeaderHelpers

  let!(:user) { create(:user) }
  let!(:notebook) { create(:notebook, user: user) }
  let!(:section) { create(:section, notebook: notebook) }
  let!(:pages) { create_list(:page, 5, section: section) }
  let(:token) { authorized_header(user)['Authorization'] }
  let(:other_user) { create(:user) }
  let(:other_user_notebook) { create(:notebook, user: other_user) }
  let(:other_user_section) { create(:section, notebook: other_user_notebook) }
  let!(:other_user_pages) { create_list(:page, 3, section: other_user_section) }
  let(:other_user_token) { authorized_header(other_user)['Authorization'] }

  describe 'GET /api/v1/users/:user_id/notebooks/:notebook_id/sections/:section_id/pages' do
    context 'when user is authenticated' do
      before { get "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections/#{section.id}/pages", headers: { 'Authorization' => token } }

      it 'returns user pages' do
        expect(json).not_to be_empty
        expect(json.size).to eq(5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when user is not authenticated' do
      before { get "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections/#{section.id}/pages" }

      it 'returns unauthorized status code' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET /api/v1/users/:user_id/notebooks/:notebook_id/sections/:section_id/pages/:id' do
    context 'when the record belongs to the user' do
      let(:page_id) { pages.first.id }

      before { get "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections/#{section.id}/pages/#{page_id}", headers: { 'Authorization' => token } }

      it 'returns the page' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(page_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not belong to the user' do
      let(:page_id) { other_user_pages.first.id }

      before { get "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections/#{section.id}/pages/#{page_id}", headers: { 'Authorization' => token } }

      it 'returns unauthorized status code' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /api/v1/users/:user_id/notebooks/:notebook_id/sections/:section_id/pages' do
    context 'with valid params' do
      let(:valid_attributes) { { title: 'Test Page', content: 'Test Content', section_id: section.id } }

      it 'creates a new page' do
        expect {
          post "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections/#{section.id}/pages", params: { page: valid_attributes }, headers: { 'Authorization' => token }
        }.to change(Page, :count).by(1)
      end

      it 'returns status code 201' do
        post "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections/#{section.id}/pages", params: { page: valid_attributes }, headers: { 'Authorization' => token }
        expect(response).to have_http_status(201)
      end
    end
  end

  describe 'PUT /api/v1/users/:user_id/notebooks/:notebook_id/sections/:section_id/pages/:id' do
    context 'when the record belongs to the user' do
      let(:page_id) { pages.first.id }
      let(:new_attributes) { { title: 'Updated Page Title' } }

      before { put "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections/#{section.id}/pages/#{page_id}", params: { page: new_attributes }, headers: { 'Authorization' => token } }

      it 'updates the page' do
        expect(json['title']).to eq(new_attributes[:title])
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not belong to the user' do
      let(:page_id) { other_user_pages.first.id }
      let(:new_attributes) { { title: 'Updated Page Title' } }

      before { put "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections/#{section.id}/pages/#{page_id}", params: { page: new_attributes }, headers: { 'Authorization' => token } }

      it 'returns unauthorized status code' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'DELETE /api/v1/users/:user_id/notebooks/:notebook_id/sections/:section_id/pages/:id' do
    context 'when the record belongs to the user' do
      let(:page_id) { pages.first.id }

      it 'destroys the requested page' do
        expect {
          delete "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections/#{section.id}/pages/#{page_id}", headers: { 'Authorization' => token }
        }.to change(Page, :count).by(-1)
      end

      it 'returns status code 204' do
        delete "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections/#{section.id}/pages/#{page_id}", headers: { 'Authorization' => token }
        expect(response).to have_http_status(204)
      end
    end

    context 'when the record does not belong to the user' do
      let(:page_id) { other_user_pages.first.id }

      it 'does not destroy the requested page' do
        expect {
          delete "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections/#{section.id}/pages/#{page_id}", headers: { 'Authorization' => token }
        }.to_not change(Page, :count)
      end

      it 'returns unauthorized status code' do
        delete "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections/#{section.id}/pages/#{page_id}", headers: { 'Authorization' => token }
        expect(response).to have_http_status(401)
      end
    end
  end
end
