require 'rails_helper'

feature 'User signs in' do
  scenario 'With valid input' do
    user = Fabricate(:user)
    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    first('input[type="submit"]').click
    expect(page).to have_content("Welcome, #{user.email}")
    expect(page).to have_link('Sign out')
  end
  scenario 'With Invalid input' do
    user = Fabricate(:user)
    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: user.email
    click_button 'Sign In'
    expect(page).to have_content('Invalid Email or password.')
  end
end
