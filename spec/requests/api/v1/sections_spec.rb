require 'rails_helper'

RSpec.describe 'Sections API', type: :request do
  include Requests::JsonHelpers
  include Requests::HeaderHelpers

  let!(:user) { create(:user) }
  let!(:notebook) { create(:notebook, user: user) }
  let!(:sections) { create_list(:section, 5, notebook: notebook) }
  let(:token) { authorized_header(user)['Authorization'] }
  let(:other_user) { create(:user) }
  let(:other_user_notebook) { create(:notebook, user: other_user) }
  let!(:other_user_sections) { create_list(:section, 3, notebook: other_user_notebook) }
  let(:other_user_token) { authorized_header(other_user)['Authorization'] }

  describe 'GET /api/v1/users/:user_id/notebooks/:notebook_id/sections' do
    context 'when user is authenticated' do
      before { get "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections", headers: { 'Authorization' => token } }

      it 'returns user sections' do
        expect(json).not_to be_empty
        expect(json.size).to eq(5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when user is not authenticated' do
      before { get "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections" }

      it 'returns unauthorized status code' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET /api/v1/users/:user_id/notebooks/:notebook_id/sections/:id' do
    context 'when the record belongs to the user' do
      let(:section_id) { sections.first.id }

      before { get "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections/#{section_id}", headers: { 'Authorization' => token } }

      it 'returns the section' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(section_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not belong to the user' do
      let(:section_id) { other_user_sections.first.id }

      before { get "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections/#{section_id}", headers: { 'Authorization' => token } }

      it 'returns unauthorized status code' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /api/v1/users/:user_id/notebooks/:notebook_id/sections' do
    context 'with valid params' do
      let(:valid_attributes) { { title: 'Test Section', notebook_id: notebook.id } }

      it 'creates a new section' do
        expect {
          post "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections", params: { section: valid_attributes }, headers: { 'Authorization' => token }
        }.to change(Section, :count).by(1)
      end

      it 'returns status code 201' do
        post "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections", params: { section: valid_attributes }, headers: { 'Authorization' => token }
        expect(response).to have_http_status(201)
      end
    end
  end

  describe 'PUT /api/v1/users/:user_id/notebooks/:notebook_id/sections/:id' do
    let(:section_id) { sections.first.id }
    let(:new_attributes) { { title: 'Updated Section Title' } }

    context 'when the record belongs to the user' do
      before { put "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections/#{section_id}", params: { section: new_attributes }, headers: { 'Authorization' => token } }

      it 'updates the section' do
        expect(json['title']).to eq(new_attributes[:title])
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not belong to the user' do
      before { put "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections/#{section_id}", params: { section: new_attributes }, headers: { 'Authorization' => other_user_token } }

      it 'returns unauthorized status code' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'DELETE /api/v1/users/:user_id/notebooks/:notebook_id/sections/:id' do
    let(:section_id) { sections.first.id }

    context 'when the record belongs to the user' do
      it 'destroys the requested section' do
        expect {
          delete "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections/#{section_id}", headers: { 'Authorization' => token }
        }.to change(Section, :count).by(-1)
      end

      it 'returns status code 204' do
        delete "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections/#{section_id}", headers: { 'Authorization' => token }
        expect(response).to have_http_status(204)
      end
    end

    context 'when the record does not belong to the user' do
      it 'does not destroy the requested section' do
        expect {
          delete "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections/#{section_id}", headers: { 'Authorization' => other_user_token }
        }.to_not change(Section, :count)
      end

      it 'returns unauthorized status code' do
        delete "/api/v1/users/#{user.id}/notebooks/#{notebook.id}/sections/#{section_id}", headers: { 'Authorization' => other_user_token }
        expect(response).to have_http_status(401)
      end
    end
  end
end
