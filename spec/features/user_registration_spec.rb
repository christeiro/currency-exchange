require 'rails_helper'

feature 'User registration' do
  scenario 'with valid input' do
    visit root_path
    click_link 'Sign Up'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign Up'
    expect(page).to have_content('Welcome, test@example.com')
    expect(page).to have_link('Sign out')
  end
  scenario 'with invalid input' do
    visit root_path
    click_link 'Sign Up'
    click_button 'Sign Up'
    expect(page).to have_content('Email can\'t be blank')
    expect(page).to have_content('Password can\'t be blank')
  end
end
