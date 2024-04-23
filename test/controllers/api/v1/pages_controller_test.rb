require "test_helper"

class Api::V1::PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @api_v1_page = api_v1_pages(:one)
  end

  test "should get index" do
    get api_v1_pages_url, as: :json
    assert_response :success
  end

  test "should create api_v1_page" do
    assert_difference("Api::V1::Page.count") do
      post api_v1_pages_url, params: { api_v1_page: { content: @api_v1_page.content, section_id: @api_v1_page.section_id, title: @api_v1_page.title } }, as: :json
    end

    assert_response :created
  end

  test "should show api_v1_page" do
    get api_v1_page_url(@api_v1_page), as: :json
    assert_response :success
  end

  test "should update api_v1_page" do
    patch api_v1_page_url(@api_v1_page), params: { api_v1_page: { content: @api_v1_page.content, section_id: @api_v1_page.section_id, title: @api_v1_page.title } }, as: :json
    assert_response :success
  end

  test "should destroy api_v1_page" do
    assert_difference("Api::V1::Page.count", -1) do
      delete api_v1_page_url(@api_v1_page), as: :json
    end

    assert_response :no_content
  end
end
