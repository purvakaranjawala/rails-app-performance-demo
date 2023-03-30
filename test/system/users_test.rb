require 'application_system_test_case'

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:charles)
  end

  test 'visiting the index' do
    visit users_url
    assert_selector 'h1', text: 'Users'
  end

  test 'should create user' do
    visit users_url
    click_on 'New user'

    fill_in 'Address', with: @user.address
    fill_in 'Name', with: @user.name
    fill_in 'Phone number', with: @user.phone_number
    click_on 'Create User'

    assert_text 'User was successfully created'
    click_on 'Back'
  end

  test 'should not create user if empty form submitted' do
    visit users_url
    click_on 'New user'

    fill_in 'Address', with: ''
    fill_in 'Name', with: ''
    fill_in 'Phone number', with: ''
    click_on 'Create User'

    assert_text '1 error prohibited this user from being saved:'
    assert_text "Name can't be blank"
    click_on 'Back'
  end

  test 'should update User' do
    visit user_url(@user)
    click_on 'Edit this user', match: :first

    fill_in 'Address', with: @user.address
    fill_in 'Name', with: @user.name
    fill_in 'Phone number', with: @user.phone_number
    click_on 'Update User'

    assert_text 'User was successfully updated'
    click_on 'Back'
  end

  test 'should destroy User' do
    visit user_url(@user)
    click_on 'Destroy this user', match: :first

    assert_text 'User was successfully destroyed'
  end
end
