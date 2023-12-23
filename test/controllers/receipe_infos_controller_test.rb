require 'test_helper'

class ReceipeInfosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @receipe_info = receipe_infos(:receipe_info_one)
  end

  test 'should get index' do
    get receipe_infos_url
    assert_response :success
  end

  test 'should get new' do
    get new_receipe_info_url
    assert_response :success
  end

  test 'should create receipe_info' do
    assert_difference('ReceipeInfo.count') do
      post receipe_infos_url,
           params: { receipe_info: { body: @receipe_info.ingredients,
                                     speciality: @receipe_info.speciality,
                                     recipe_id: Recipe.first,
                                     ingredients: @receipe_info.ingredients,
                                     origin: @receipe_info.origin,
                                     posted_at: @receipe_info.posted_at,
                                     title: @receipe_info.title } }
    end

    assert_redirected_to receipe_info_url(ReceipeInfo.last)
  end

  test 'should show receipe_info' do
    get receipe_info_url(@receipe_info)
    assert_response :success
  end

  test 'should get edit' do
    get edit_receipe_info_url(@receipe_info)
    assert_response :success
  end

  test 'should update receipe_info' do
    patch receipe_info_url(@receipe_info),
          params: { receipe_info: { ingredients: @receipe_info.ingredients,
                                    posted_at: @receipe_info.posted_at,
                                    origin: "German",
                                    title: @receipe_info.title } }
    assert_redirected_to receipe_info_url(@receipe_info)
  end

  test 'should destroy receipe_info' do
    assert_difference('ReceipeInfo.count', -1) do
      delete receipe_info_url(@receipe_info)
    end

    assert_redirected_to receipe_infos_url
  end
end
