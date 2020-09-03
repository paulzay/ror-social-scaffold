 
require 'rails_helper'

RSpec.feature 'Friendships', type: :feature do
  scenario 'Send friend request' do
    @user =
      User.new(
        name: 'User1',
        email: 'user1@email.com',
        password: '123123',
        password_confirmation: '123123'
      )
    @user.save
    @friend =
      User.new(
        name: 'User2',
        email: 'user2@email.com',
        password: '123123',
        password_confirmation: '123123'
      )
    @friend.save
    visit 'users/sign_in'
    fill_in 'user_email', with: 'user1@email.com'
    fill_in 'user_password', with: '123123'
    click_on 'Log in'

    visit "users/#{@friend.id}"
    click_on 'Add Friend'

    expect(page).not_to have_text('Add Friend')
  end
end
