require "test_helper"

class Api::V1::NotebooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @api_v1_notebook = api_v1_notebooks(:one)
  end

  test "should get index" do
    get api_v1_notebooks_url, as: :json
    assert_response :success
  end

  test "should create api_v1_notebook" do
    assert_difference("Api::V1::Notebook.count") do
      post api_v1_notebooks_url, params: { api_v1_notebook: { title: @api_v1_notebook.title, user_id: @api_v1_notebook.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show api_v1_notebook" do
    get api_v1_notebook_url(@api_v1_notebook), as: :json
    assert_response :success
  end

  test "should update api_v1_notebook" do
    patch api_v1_notebook_url(@api_v1_notebook), params: { api_v1_notebook: { title: @api_v1_notebook.title, user_id: @api_v1_notebook.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy api_v1_notebook" do
    assert_difference("Api::V1::Notebook.count", -1) do
      delete api_v1_notebook_url(@api_v1_notebook), as: :json
    end

    assert_response :no_content
  end
end
