# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/', type: :feature do
  describe 'landing page' do
    let!(:user1) { User.create!(name: 'Michael', email: 'mcalla123@gmail.com', password: "test123", password_confirmation: "test123") }
    let!(:user2) { User.create!(name: 'Garrett', email: 'garrett123@gmail.com', password: "test123", password_confirmation: "test123") }

    before(:each) do
      visit '/'
    end

    it 'displays the application title' do
      expect(page).to have_content('Viewing Party')
    end

    it 'displays a button to create a new user' do
      expect(page).to have_button('Create New User')
      click_button 'Create New User'

      expect(current_path).to eq('/register')
    end

    it 'displays a link to go back to the landing page' do
      expect(page).to have_link('Home', href: '/')
    end

    it 'displays a link thats take you to the login page' do
      click_link "Log In"

      expect(current_path).to eq(login_path)
    end

    it 'does not display a Log In link if a session is active' do
      click_link "Log In"
      fill_in :email, with: user1.email
      fill_in :password, with: user1.password
      click_button "Log In"

      visit '/'

      expect(page).to_not have_link("Log In")
    end

    it 'displays a Log Out link, and no log in or create user, if a session is active' do
      click_link "Log In"
      fill_in :email, with: user1.email
      fill_in :password, with: user1.password
      click_button "Log In"

      visit '/'

      expect(page).to_not have_link("Log In")
      expect(page).to_not have_button("Create New User")

      click_link "Log Out"

      expect(current_path).to eq(root_path)

      expect(page).to have_link("Log In")
      expect(page).to have_button("Create New User")
    end

    describe 'as a visitor' do
      it 'no longer displays a list of existing users' do
        expect(page).to_not have_link(user1.email.to_s, href: dashboard_path(user1))
        expect(page).to_not have_link(user2.email.to_s, href: dashboard_path(user2))
      end

      it 'does not allow visitors to travel to the dashboard' do
        visit '/dashboard'

        expect(current_path).to eq('/')
        expect(page).to have_content('Must be registered and logged in to view dashboard')
      end

      it 'does not allow a visitor to create a viewing party', :vcr do
        visit movie_path(238)

        click_button "Create Viewing Party for The Godfather"

        expect(current_path).to eq(movie_path(238))
        expect(page).to have_content('Must be registered and logged in to create a Viewing Party')
      end
    end

    describe 'as a registered user' do
      it 'displays the registered users as a list, not links' do
        click_link "Log In"
        fill_in :email, with: user1.email
        fill_in :password, with: user1.password
        click_button "Log In"
  
        visit root_path

        within ".existing-users" do
          expect(page).to_not have_link(user1.email)
          expect(page).to_not have_link(user2.email)

          expect(page).to have_content(user1.email)
          expect(page).to have_content(user2.email)
        end
      end
    end
  end
end
